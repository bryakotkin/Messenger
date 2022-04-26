//
//  PixabayImagePickerView.swift
//  tinkoff-chat
//
//  Created by Nikita on 26.04.2022.
//

import UIKit

class PixabayImagePickerView: UIView {
    
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.imagePickerCell.rawValue)
        
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addSubview(imageCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
