//
//  ProfileViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.02.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var prevProfile: Profile?
    
    var model: IProfileModel
    
    var mainView: ProfileView? {
        return view as? ProfileView
    }
    
    init(model: IProfileModel) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ProfileView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProfileData()
    
        self.hideKeyboardWhenTappedAround()
        setupNavigationBar()
        isHiddenCancelGCDOperationButtons(true)
        
        mainView?.delegate = self
        mainView?.usernameTextField.delegate = self
        mainView?.descriptionTextView.delegate = self
        
//        Значения нулевые, потому что view добавлена в иерархию, но констрейнты еще не посчитаны
//        print(#function, mainView?.editButton.frame)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView?.defaultCenter = mainView?.gcdButton.center
        mainView?.defaultTransform = mainView?.gcdButton.transform
        
//        Значения размеров и положение не нулевые, потому что всё посчитано и отображено пользователю
//        print(#function, mainView?.editButton.frame)
    }
    
    override func viewDidLayoutSubviews() {
        guard let width = mainView?.userImageView.bounds.width else { return }
        mainView?.userImageView.layer.cornerRadius = width / 2
    }
    
    private func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonAction))
        navigationItem.rightBarButtonItem = cancelButton
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ServiceAssembly.themeService.currentTheme?.titleControllerColor ?? .black
        ]
    }
    
    func setupFields() {
        mainView?.usernameTextField.text = prevProfile?.username
        mainView?.descriptionTextView.text = prevProfile?.description
        mainView?.userImageView.image = prevProfile?.image
        
        isEnabledFields(false)
    }
    
    func showImagePicker(type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePicker = UIImagePickerController()

            imagePicker.sourceType = type
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("\(type.rawValue) not available")
        }
    }
    
    func showImagePicker() {
        let controller = PresentationAssembly.pixabayImagePickerViewController
        
        controller.completionHandler = { [weak self] image in
            guard let self = self else { return }
            self.mainView?.userImageView.image = image
            self.mainView?.startAnimationSaveButton()
            self.isHiddenCancelGCDOperationButtons(false)
            self.isEnabledFields(true)
            self.isEnabledGCDOperationButtons(true)
        }
        
        present(controller, animated: true)
    }
    
    @objc private func cancelBarButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TextField, TextView, Image Logics

extension ProfileViewController {
    func isEnabledFields(_ isEnabled: Bool) {
        mainView?.usernameTextField.isEnabled = isEnabled
        mainView?.descriptionTextView.isUserInteractionEnabled = isEnabled
    }
    
    func isTextFieldHaveNewValue() -> Bool {
        let username = mainView?.usernameTextField.text
        
        if username == prevProfile?.username {
            return false
        }
        return true
    }
    
    func isTextViewHaveNewValues() -> Bool {
        let desctiption = mainView?.descriptionTextView.text
        
        if desctiption == prevProfile?.description {
            return false
        }
        return true
    }
    
    func isImageNew() -> Bool {
        guard let newImg = mainView?.userImageView.image else { return false }
        guard let prevImg = prevProfile?.image else { return true }
        
        return !prevImg.isEqual(newImg)
    }
}

// MARK: - Buttons Logics

extension ProfileViewController {
    func isHiddenCancelGCDOperationButtons(_ isHidden: Bool) {
        mainView?.cancelButton.isHidden = isHidden
        mainView?.gcdButton.isHidden = isHidden
        mainView?.editButton.isHidden = !isHidden
    }
    
    func isEnabledGCDOperationButtons(_ isEnabled: Bool) {
        mainView?.gcdButton.isEnabled = isEnabled
    }
    
    func updateGCDOperationButtonsState() {
        isTextFieldHaveNewValue() || isTextViewHaveNewValues() || isImageNew() ? isEnabledGCDOperationButtons(true) : isEnabledGCDOperationButtons(false)
    }
}

// MARK: - GCD Work

extension ProfileViewController {
    func saveData() {
        let username = mainView?.usernameTextField.text
        let description = mainView?.descriptionTextView.text
        let image = mainView?.userImageView.image
        
        let profile = Profile(username: username, description: description, image: image)
        
        mainView?.activityIndicator.startAnimating()
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
        
        model.saveProfileData(profile: profile, flags: (isUsernameNew, isDescriptionNew, isImageNew)) { [weak self] isSaved in
            self?.mainView?.activityIndicator.stopAnimating()
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
    
    func fetchProfileData() {
        isEnabledEditButtons(false)
        model.fetchProfileData { [weak self] profile in
            guard let self = self else { return }
            self.isEnabledEditButtons(true)
            self.prevProfile = profile
            self.setupFields()
        }
    }
}
