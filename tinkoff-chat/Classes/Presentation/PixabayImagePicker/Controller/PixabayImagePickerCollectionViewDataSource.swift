//
//  PixabayImagePickerCollectionViewDataSource.swift
//  tinkoff-chat
//
//  Created by Nikita on 26.04.2022.
//

import UIKit

class PixabayImagePickerCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imagePickerCell.rawValue,
                                                      for: indexPath)
        cell.backgroundColor = .cyan
        
        return cell
    }
}   
