//
//  ProfileViewController+Delegates.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import UIKit

// MARK: - ProfileViewController: ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    func editImageButtonAction() {
        let alert = UIAlertController(title: nil, message: "Выберите изображение профиля", preferredStyle: .actionSheet)
                
        let galeryAction = UIAlertAction(title: "Установить из галлереи", style: .default) { [weak self] _ in
            self?.showImagePicker(type: .photoLibrary)
        }
                
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] _ in
            self?.showImagePicker(type: .camera)
        }
        
        let pickerControllerAction = UIAlertAction(title: "Загрузить", style: .default) { [weak self] _ in
            self?.showImagePicker()
        }
                
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
                
        alert.addAction(galeryAction)
        alert.addAction(cameraAction)
        alert.addAction(pickerControllerAction)
        alert.addAction(cancelAction)
                
        present(alert, animated: true, completion: nil)
    }
    
    func editButtonAction() {
        isEnabledFields(true)
        mainView?.usernameTextField.becomeFirstResponder()
        isHiddenCancelGCDOperationButtons(false)
        isEnabledGCDOperationButtons(false)
    }
    
    func cancelButtonAction() {
        isHiddenCancelGCDOperationButtons(true)
        setupFields()
    }
    
    func isEnabledEditButtons(_ isEnabled: Bool) {
        mainView?.editImageButton.isEnabled = isEnabled
        mainView?.editButton.isEnabled = isEnabled
    }
    
    func gcdButtonAction() {
        let service = ServiceAssembly.gcdService
        model.updateConcurrencyService(service)
        saveData()
    }
    
    func operationButtonAction() {
        let service = ServiceAssembly.operationsService
        model.updateConcurrencyService(service)
        saveData()
    }
}

// MARK: - ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            mainView?.userImageView.image = image
            isHiddenCancelGCDOperationButtons(false)
            isEnabledFields(true)
            isEnabledGCDOperationButtons(true)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ProfileViewController: UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateGCDOperationButtonsState()
    }
}

// MARK: - ProfileViewController: UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        updateGCDOperationButtonsState()
    }
}
