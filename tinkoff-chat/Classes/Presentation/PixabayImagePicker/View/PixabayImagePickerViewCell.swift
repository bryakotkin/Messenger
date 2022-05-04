//
//  PixabayImagePickerViewCell.swift
//  tinkoff-chat
//
//  Created by Nikita on 27.04.2022.
//

import Foundation
import UIKit

class PixabayImagePickerViewCell: UICollectionViewCell {
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "no-image-placeholder")
        view.backgroundColor = .cyan
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var pixabayImage: UIImage? {
        didSet {
            imageView.image = pixabayImage
        }
    }
    
    var task: Task<(), Never>?
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstarints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        task?.cancel()
        task = nil
        
        pixabayImage = UIImage(named: "no-image-placeholder")
        
        super.prepareForReuse()
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageView)
    }
    
    private func setupConstarints() {
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
