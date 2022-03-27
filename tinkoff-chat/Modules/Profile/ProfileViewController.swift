//
//  ProfileViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.02.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var prevProfile: Profile?
    var dataManager: MultithreadingManager = GCDManager()
    
    var mainView: ProfileView {
        return view as! ProfileView
    }
    
    override func loadView() {
        self.view = ProfileView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    
        self.hideKeyboardWhenTappedAround()
        setupNavigationBar()
        isHiddenCancelGCDOperationButtons(true)
        
        mainView.delegate = self
        mainView.usernameTextField.delegate = self
        mainView.descriptionTextView.delegate = self
        
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
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonAction))
        navigationItem.rightBarButtonItem = cancelButton
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.shared.currentTheme?.titleControllerColor ?? .black]
    }
    
    private func setupFields() {
        mainView.usernameTextField.text = prevProfile?.username
        mainView.descriptionTextView.text = prevProfile?.description
        mainView.userImageView.image = prevProfile?.image
        
        isEnabledFields(false)
    }
    
    private func showImagePicker(type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePicker = UIImagePickerController()

            imagePicker.sourceType = type
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("\(type.rawValue) not available")
        }
    }
    
    @objc private func cancelBarButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ProfileViewController: ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    func editImageButtonAction() {
        let alert = UIAlertController(title: nil, message: "Выберите изображение профиля", preferredStyle: .actionSheet)
                
        let galeryAction = UIAlertAction(title: "Установить из галлереи", style: .default) { action in
            self.showImagePicker(type: .photoLibrary)
        }
                
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { action in
            self.showImagePicker(type: .camera)
        }
                
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
                
        alert.addAction(galeryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
                
        present(alert, animated: true, completion: nil)
    }
    
    func editButtonAction() {
        isEnabledFields(true)
        mainView.usernameTextField.becomeFirstResponder()
        isHiddenCancelGCDOperationButtons(false)
        isEnabledGCDOperationButtons(false)
    }
    
    func cancelButtonAction() {
        isHiddenCancelGCDOperationButtons(true)
        setupFields()
    }
    
    func isEnabledEditButtons(_ isEnabled: Bool) {
        mainView.editImageButton.isEnabled = isEnabled
        mainView.editButton.isEnabled = isEnabled
    }
    
    func gcdButtonAction() {
        dataManager = GCDManager()
        saveData()
    }
    
    func operationButtonAction() {
        dataManager = OperationsManager()
        saveData()
    }
}

// MARK: - TextField, TextView, Image Logics

extension ProfileViewController {
    func isEnabledFields(_ isEnabled: Bool) {
        mainView.usernameTextField.isEnabled = isEnabled
        mainView.descriptionTextView.isUserInteractionEnabled = isEnabled
    }
    
    func isTextFieldHaveNewValue() -> Bool {
        let username = mainView.usernameTextField.text
        
        if username == prevProfile?.username {
            return false
        }
        return true
    }
    
    func isTextViewHaveNewValues() -> Bool {
        let desctiption = mainView.descriptionTextView.text
        
        if desctiption == prevProfile?.description {
            return false
        }
        return true
    }
    
    func isImageNew() -> Bool {
        guard let newImg = mainView.userImageView.image else { return false }
        guard let prevImg = prevProfile?.image else { return true }
        
        return !prevImg.isEqual(newImg)
    }
}

// MARK: - Buttons Logics

extension ProfileViewController {
    func isHiddenCancelGCDOperationButtons(_ isHidden: Bool) {
        mainView.cancelButton.isHidden = isHidden
        mainView.gcdButton.isHidden = isHidden
        mainView.operationButton.isHidden = isHidden
        mainView.editButton.isHidden = !isHidden
    }
    
    func isEnabledGCDOperationButtons(_ isEnabled: Bool) {
        mainView.gcdButton.isEnabled = isEnabled
        mainView.operationButton.isEnabled = isEnabled
    }
    
    func updateGCDOperationButtonsState() {
        isTextFieldHaveNewValue() || isTextViewHaveNewValues() || isImageNew() ? isEnabledGCDOperationButtons(true) : isEnabledGCDOperationButtons(false)
    }
}

// MARK: - ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            mainView.userImageView.image = image
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

// MARK: - GCD Work

extension ProfileViewController {
    func saveData() {
        let username = mainView.usernameTextField.text
        let description = mainView.descriptionTextView.text
        let image = mainView.userImageView.image
        
        let profile = Profile(username: username, description: description, image: image)
        
        mainView.activityIndicator.startAnimating()
        isEnabledFields(false)
        isEnabledGCDOperationButtons(false)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Повторить", style: .destructive) { [weak self] _ in
            self?.saveData()
        }
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        
        let isUsernameNew = isTextFieldHaveNewValue()
        let isDescriptionNew = isTextViewHaveNewValues()
        let isImageNew = isImageNew()
        
        dataManager.saveData(profile, flags: (isUsernameNew, isDescriptionNew, isImageNew)) { [weak self] isSaved in
            self?.mainView.activityIndicator.stopAnimating()
            alertController.addAction(cancelAction)
            
            if isSaved {
                alertController.message = "Данные сохранены"
                self?.isHiddenCancelGCDOperationButtons(true)
                self?.prevProfile = profile
            } else {
                alertController.title = "Ошибка"
                alertController.message = "Не удалось сохранить данные"
                alertController.addAction(retryAction)
                self?.isEnabledFields(true)
                self?.isEnabledGCDOperationButtons(true)
            }
            
            let rootVC = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController
            let presented = rootVC?.presentedViewController
            if let presented = presented {
                presented.present(alertController, animated: true)
            } else {
                rootVC?.present(alertController, animated: true)
            }
        }
    }
    
    func getData() {
        isEnabledEditButtons(false)
        dataManager.getData { [weak self] profile in
            self?.isEnabledEditButtons(true)
            self?.prevProfile = profile
            self?.setupFields()
        }
    }
}
