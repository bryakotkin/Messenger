//
//  PixabayImagePickerViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 26.04.2022.
//

import UIKit

class PixabayImagePickerViewController: UIViewController {
    
    let collectionDelegate: UICollectionViewDelegate
    let collectionDataSource: UICollectionViewDataSource
    
    var mainView: PixabayImagePickerView? {
        return view as? PixabayImagePickerView
    }
    
    init() {
        collectionDelegate = PixabayImagePickerCollectionViewDelegate()
        collectionDataSource = PixabayImagePickerCollectionViewDataSource()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PixabayImagePickerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView?.imageCollectionView.delegate = collectionDelegate
        mainView?.imageCollectionView.dataSource = collectionDataSource
    }
}
