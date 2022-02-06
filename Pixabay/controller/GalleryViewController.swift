//
//  ViewController.swift
//  Pixabay
//
//  Created by Askar on 02.02.2022.
//

import UIKit
import SnapKit
import Kingfisher
import AVFoundation
import ChameleonFramework
import AVKit

class GalleryViewController: UIViewController, UICollectionViewDelegate {

    private let apiKey = "25518435-6f4fd9c799c564b4c70f1cbad"
    private var pagingNumber = 1
    
    var imageHits: [ImageHit] = []
    var videoHits: [VideoHit] = []
    var contentType: ContentType = .image
    let segmentItems = ["Images", "Movies"]
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return collectionView
    }()
    lazy var segmentControl: UISegmentedControl = {
        let view = UISegmentedControl(items: segmentItems)
        view.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        view.selectedSegmentIndex = 0
        return view
    }()
    var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.backgroundImage = UIImage()
        return search
    }()

    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImages()
        
        addControl()
        addSearchBar()
        addCollectionView()
        edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.title = "Movies & Images"
    }
    
    // MARK: Fetching Media Methods
    
    func fetchImages(query: String = "", pageNumber: Int = 1) {
        let queryWithNoSpaces = query.replacingOccurrences(of: " ", with: "&")
        let stringURL = "https://pixabay.com/api/?key=\(apiKey)&q=\(queryWithNoSpaces)&image_type=photo&pretty=true&page=\(pageNumber)"
        guard let url = URL(string: stringURL) else {fatalError("No URL was found!")}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {fatalError()}
            do {
                let jsonHits = try JSONDecoder().decode(ImageResponse.self, from: data)
                DispatchQueue.main.async {
                    self.imageHits.append(contentsOf: jsonHits.hits)
                    self.collectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchVideos(query: String = "", pageNumber: Int = 1) {
        let queryWithNoSpaces = query.replacingOccurrences(of: " ", with: "+")
        let stringURL = "https://pixabay.com/api/videos/?key=\(apiKey)&q=\(queryWithNoSpaces)"
        guard let url = URL(string: stringURL) else {fatalError("No URL was found!")}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {fatalError()}
            do {
                let jsonHits = try JSONDecoder().decode(VideoResponse.self, from: data)
                DispatchQueue.main.async {
                    self.videoHits.append(contentsOf: jsonHits.hits)
                    self.collectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    // MARK: Add UI Elements Methods
    
    func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - UISegmented Control Methods
    
    func addControl() {
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
       switch (segmentedControl.selectedSegmentIndex) {
          case 0: self.contentType = .image
          case 1: self.contentType = .video
          default:
          break
       }
        collectionView.reloadData()
    }
    
    // MARK: Search Bar Methods
    
    func addSearchBar() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        searchBar.delegate = self
    }
}

    // MARK: - Collection View Data Source Methods

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch contentType {
        case .image: return imageHits.count
        case .video: return videoHits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        cell.layer.cornerRadius = 8
        switch contentType {
        case .image:
            let urlString = imageHits[indexPath.row].previewURL
            cell.backgroundColor = UIColor(hexString: "#EDF8EB")
            cell.configure(with: urlString)
        case .video:
            cell.backgroundColor = UIColor(hexString: "#1e6bdf")?.withAlphaComponent(0.2)
            cell.configureDefault()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch contentType {
        case .image:
            let imageURL = imageHits[indexPath.row].largeImageURL
            let detailsVC = DetailsViewController(imageURL: imageURL)
            detailsVC.modalPresentationStyle = .overCurrentContext
            detailsVC.modalTransitionStyle = .crossDissolve
            present(detailsVC, animated: true)
        case .video:
            let urlString = videoHits[indexPath.row].videos.medium.url
            guard let url = URL(string: urlString) else { return }
            let player = AVPlayer(url: url)
            let playerController = AVPlayerViewController()
            playerController.player = player
            playerController.allowsPictureInPicturePlayback = true
            playerController.player?.play()
            self.present(playerController, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        
        if offsetY > height - scrollView.frame.size.height {
            pagingNumber += 1
            switch contentType {
            case .image:
                fetchImages(query: searchBar.text ?? "", pageNumber: pagingNumber)
            case .video:
                fetchVideos(query: searchBar.text ?? "", pageNumber: pagingNumber)
            }
        }
    }
}

    // MARK: - Collection View Delegate Flow Layout Methods

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 160)
    }
}

extension GalleryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            switch contentType {
            case .image:
                self.imageHits = []
                self.pagingNumber = 1
                self.fetchImages(query: text)
                self.collectionView.reloadData()
            case .video:
                self.videoHits = []
                self.pagingNumber = 1
                self.fetchVideos(query: text)
                self.collectionView.reloadData()
            }
        }
    }
}
