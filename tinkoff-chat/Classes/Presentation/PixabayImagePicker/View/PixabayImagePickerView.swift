//
//  PixabayImagePickerView.swift
//  tinkoff-chat
//
//  Created by Nikita on 26.04.2022.
//

import UIKit

protocol PixabayImagePickerViewDelegate: AnyObject {
    func fetchCurrentTheme() -> Theme?
}

class PixabayImagePickerView: UIView {
    
    weak var delegate: PixabayImagePickerViewDelegate?
    
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 8
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(PixabayImagePickerViewCell.self, forCellWithReuseIdentifier: Constants.imagePickerCell.rawValue)
        
        return collection
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTheme() {
        let theme = delegate?.fetchCurrentTheme()
        
        backgroundColor = theme?.backgroundColor
        imageCollectionView.backgroundColor = theme?.backgroundColor
    }
    
    private func setupSubviews() {
        addSubview(imageCollectionView)
        addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
