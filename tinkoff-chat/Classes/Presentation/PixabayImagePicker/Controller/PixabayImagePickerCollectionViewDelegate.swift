//
//  PixabayImagePickerCollectionViewDelegate.swift
//  tinkoff-chat
//
//  Created by Nikita on 26.04.2022.
//

import UIKit

protocol PixabayImagePickerCollectionViewDelegateProtocol: AnyObject {
    func cellDidSelect(by indexPath: IndexPath)
}

class PixabayImagePickerCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: PixabayImagePickerCollectionViewDelegateProtocol?
    
    private func getLayoutInset(layout: UICollectionViewLayout) -> CGFloat {
        guard let layout = layout as? UICollectionViewFlowLayout else { return 0 }
        return layout.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = getLayoutInset(layout: collectionViewLayout)
        let size = (collectionView.frame.width - inset * 4) / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = getLayoutInset(layout: collectionViewLayout)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellDidSelect(by: indexPath)
    }
}
