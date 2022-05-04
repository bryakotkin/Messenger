//
//  PixabayImagePickerCollectionViewDataSource.swift
//  tinkoff-chat
//
//  Created by Nikita on 26.04.2022.
//

import UIKit

class PixabayImagePickerCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var cache = NSCache<NSNumber, UIImage>()
    
    var imagesURLs: [ImageURL]?
    var model: IPixabayImagePickerModel

    init(model: IPixabayImagePickerModel) {
        self.model = model
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.imagePickerCell.rawValue,
            for: indexPath
        ) as? PixabayImagePickerViewCell else { return UICollectionViewCell() }
        
        guard let imageURL = imagesURLs?[indexPath.row] else { return cell }
        
        let index = NSNumber(value: indexPath.row)
        if let image = cache.object(forKey: index) {
            cell.pixabayImage = image
        } else {
            let task = Task {
                cell.indexPath = indexPath
                let image = try? await model.fetchImage(imageURL: imageURL)
                if let image = image {
                    if !Task.isCancelled {
                        cell.pixabayImage = image
                    }
                
                    cache.setObject(image, forKey: index)
                }
            }
            
            cell.task = task
        }
        
        return cell
    }
}   
