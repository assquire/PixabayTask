//
//  ImageCollectionViewCell.swift
//  Pixabay
//
//  Created by Askar on 03.02.2022.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    var defaultImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    lazy var imageView: UIImageView = {
        let view = UIImageView()
//        view.contentMode = .scaleToFill
        return view
    }()
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(17)
        label.text = "Name"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImage()
        addLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else {return}
        DispatchQueue.main.async {
            self.imageView.kf.setImage(with: url)
            self.contentView.addSubview(self.imageView)
        }
    }
    
    func configureDefault() {
        self.imageView.contentMode = .scaleAspectFit
        DispatchQueue.main.async {
            self.imageView.image = UIImage(named: "default-play")
            self.contentView.addSubview(self.imageView)
        }
    }
    
    func addLabel() {
        contentView.addSubview(userLabel)
        userLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.bottom.trailing.leading.equalToSuperview().inset(10)
        }
    }
    
    func addImage() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
}
