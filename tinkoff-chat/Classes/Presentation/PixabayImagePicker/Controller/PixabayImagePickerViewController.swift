//
//  PixabayImagePickerViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 26.04.2022.
//

import UIKit

class PixabayImagePickerViewController: UIViewController {
    
    let model: IPixabayImagePickerModel
    
    let collectionDelegate: PixabayImagePickerCollectionViewDelegate
    let collectionDataSource: PixabayImagePickerCollectionViewDataSource
    
    var completionHandler: ((UIImage) -> Void)?
    
    var mainView: PixabayImagePickerView? {
        return view as? PixabayImagePickerView
    }
    
    init(model: IPixabayImagePickerModel) {
        self.model = model
        
        collectionDelegate = PixabayImagePickerCollectionViewDelegate()
        collectionDataSource = PixabayImagePickerCollectionViewDataSource(model: model)
        
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
        
        collectionDelegate.delegate = self
        
        fetchImagesList()
    }
    
    private func fetchImagesList() {
        Task {
            mainView?.activityIndicator.startAnimating()
            let imagesURLs = try? await model.fetchImagesList().imagesURLs
            mainView?.activityIndicator.stopAnimating()
            collectionDataSource.imagesURLs = imagesURLs
            mainView?.imageCollectionView.reloadData()
        }
    }
}

// MARK: - PixabayImagePickerViewController: PixabayImagePickerCollectionViewDelegateProtocol

extension PixabayImagePickerViewController: PixabayImagePickerCollectionViewDelegateProtocol {
    func cellDidSelect(by indexPath: IndexPath) {
        let index = NSNumber(value: indexPath.row)
        guard let image = collectionDataSource.cache.object(forKey: index) else {
            let alertController = UIAlertController(title: "Ошибка",
                                                    message: "Изображение ещё не было загружено. Попробуйте позже",
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
            
            alertController.addAction(cancelAction)
            
            return present(alertController, animated: true)
        }
        
        completionHandler?(image)
        dismiss(animated: true)
    }
}
