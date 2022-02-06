//
//  DetailsViewController.swift
//  Pixabay
//
//  Created by Askar on 04.02.2022.
//

import UIKit
import SnapKit
import Kingfisher

class DetailsViewController: UIViewController {

    var imageURL: String?
    var fullImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        return image
    }()
    var dismissLabel: UILabel = {
        let label = UILabel()
        label.text = "Dismiss"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28.0)
        return label
    }()
    
    init(imageURL: String) {
        super.init(nibName: nil, bundle: nil)
        self.imageURL = imageURL
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        addImage()
        addLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    // MARK: Add UI Elements Methods
    
    func addImage() {
        view.addSubview(fullImageView)
        if let urlString = imageURL {
            let url = URL(string: urlString)
            fullImageView.snp.makeConstraints { make in
                make.width.equalTo(view.frame.width)
                make.height.equalTo(150)
                make.centerY.centerX.equalToSuperview()
            }
            fullImageView.kf.setImage(with: url)
        }
    }
    
    func addLabel() {
        view.addSubview(dismissLabel)
        dismissLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func viewTapped() {
        dismiss(animated: false)
    }
}

    // MARK: - UI Gesture Recognizer Delegate Methods

extension DetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
