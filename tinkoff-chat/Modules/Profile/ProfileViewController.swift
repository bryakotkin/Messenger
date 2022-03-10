//
//  ProfileViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.02.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var mainView: ProfileView {
        return view as! ProfileView
    }
    
    override func loadView() {
        self.view = ProfileView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        setupNavigationBar()
        
        mainView.delegate = self
        
//        Значения нулевые, потому что view добавлена в иерархию, но констрейнты еще не посчитаны
//        print(#function, mainView.editButton.frame)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        Значения размеров и положение не нулевые, потому что всё посчитано и отображено пользователю
//        print(#function, mainView.editButton.frame)
    }
    
    override func viewDidLayoutSubviews() {
        mainView.userImageView.layer.cornerRadius = mainView.userImageView.bounds.width / 2
    }
    
    private func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    private func showImagePicker(type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePicker = UIImagePickerController()

            imagePicker.sourceType = type
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("\(type.rawValue) not available")
        }
    }
    
    @objc private func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ProfileViewController: ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    
    func editButtonAction() {
        let alert = UIAlertController(title: nil, message: "Выберите изображение профиля", preferredStyle: .actionSheet)
                
        let galeryAction = UIAlertAction(title: "Установить из галлереи", style: .default) { action in
            self.showImagePicker(type: .photoLibrary)
        }
                
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { action in
            self.showImagePicker(type: .camera)
        }
                
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                
        alert.addAction(galeryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
                
        present(alert, animated: true, completion: nil)
    }
    
    func saveButtonAction() {
        print("SaveButton pressed")
    }
}

// MARK: - ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            mainView.userImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
