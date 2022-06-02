//
//  ProfileView.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.02.2022.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    func editImageButtonAction()
    func editButtonAction()
    func cancelButtonAction()
    func gcdButtonAction()
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewProtocol?
    
    var defaultCenter: CGPoint?
    var defaultTransform: CGAffineTransform?
    
    let userImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = CustomColors.lightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.accessibilityIdentifier = "userImageView"
        
        return view
    }()
    
    let usernameTextField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 24, weight: .bold)
        field.placeholder = "ФИО"
        field.clearButtonMode = .whileEditing
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.accessibilityIdentifier = "usernameTextField"
        
        return field
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.accessibilityIdentifier = "activityIndicator"
        
        return indicator
    }()

    let descriptionTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "descriptionTextView"
        
        return view
    }()
    
    let editImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(CustomColors.lightBlue, for: .normal)
        button.setTitleColor(CustomColors.lightBlueAlpha, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "editImageButton"
        
        return button
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(CustomColors.lightBlue, for: .normal)
        button.setTitleColor(CustomColors.lightBlueAlpha, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.backgroundColor = CustomColors.lightGrey
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.accessibilityIdentifier = "editButton"
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(CustomColors.lightBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.backgroundColor = CustomColors.lightGrey
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.accessibilityIdentifier = "cancelButton"
        
        return button
    }()
    
    let gcdButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(CustomColors.lightBlue, for: .normal)
        button.setTitleColor(CustomColors.lightBlueAlpha, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.backgroundColor = CustomColors.lightGrey
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.accessibilityIdentifier = "gcdButton"
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userImageView)
        addSubview(usernameTextField)
        addSubview(descriptionTextView)
        addSubview(editImageButton)
        addSubview(editButton)
        addSubview(cancelButton)
        addSubview(gcdButton)
        addSubview(activityIndicator)

        addTargets()
        updateTheme()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTargets() {
        editImageButton.addTarget(self, action: #selector(editImageButtonAction), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        gcdButton.addTarget(self, action: #selector(gcdButtonAction), for: .touchUpInside)
    }
    
    private func updateTheme() {
        let theme = ServiceAssembly.themeService.theme
        
        usernameTextField.textColor = theme?.labelColor
        
        if let placeHolderColor = theme?.labelColor {
            usernameTextField.attributedPlaceholder = NSAttributedString(
                string: "ФИО",
                attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor.withAlphaComponent(0.5)]
            )
        }
        
        if let clearButton = usernameTextField.value(forKey: "_clearButton") as? UIButton {
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = theme?.labelColor.withAlphaComponent(0.5)
        }
        
        descriptionTextView.textColor = theme?.labelColor
        descriptionTextView.backgroundColor = theme?.backgroundColor
        backgroundColor = theme?.backgroundColor
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        let userImageViewConstraint = [
            userImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            userImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            userImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2 / 3),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor)
        ]
        
        let activityIndicatorConstraint = [
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: editImageButton.bottomAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor)
        ]
        
        let usernameTextFieldConstraint = [
            usernameTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            usernameTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
        ]
        
        let descriptionConstraint = [
            descriptionTextView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            descriptionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            descriptionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ]
        
        let editImageButtonConstraint = [
            editImageButton.centerXAnchor.constraint(equalTo: userImageView.rightAnchor),
            editImageButton.centerYAnchor.constraint(equalTo: userImageView.bottomAnchor)
        ]
        
        let editButtonConstraint = [
            editButton.topAnchor.constraint(equalTo: gcdButton.topAnchor),
            editButton.bottomAnchor.constraint(equalTo: gcdButton.bottomAnchor),
            editButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ]
        
        let cancelButtonConstraint = [
            cancelButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalTo: editButton.widthAnchor),
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        let gcdButtonConstraint = [
            gcdButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            gcdButton.leftAnchor.constraint(equalTo: cancelButton.leftAnchor),
            gcdButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 20),
            gcdButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        constraints.append(contentsOf: usernameTextFieldConstraint)
        constraints.append(contentsOf: userImageViewConstraint)
        constraints.append(contentsOf: activityIndicatorConstraint)
        constraints.append(contentsOf: descriptionConstraint)
        constraints.append(contentsOf: editButtonConstraint)
        constraints.append(contentsOf: editImageButtonConstraint)
        constraints.append(contentsOf: cancelButtonConstraint)
        constraints.append(contentsOf: gcdButtonConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func editImageButtonAction() {
        delegate?.editImageButtonAction()
    }
    
    @objc private func editButtonAction() {
        delegate?.editButtonAction()
        startAnimationSaveButton()
    }
    
    @objc private func cancelButtonAction() {
        delegate?.cancelButtonAction()
        stopAnimationSaveButton()
    }
    
    @objc private func gcdButtonAction() {
        delegate?.gcdButtonAction()
        stopAnimationSaveButton()
    }
}

// MARK: - Animation for edit button

extension ProfileView {
    func startAnimationSaveButton() {
        guard let defaultCenter = defaultCenter, let defaultTransform = defaultTransform else { return }
        
        UIView.animateKeyframes(
            withDuration: 0.3,
            delay: 0,
            options: [.allowUserInteraction, .repeat]
        ) { [weak self] in
            guard let self = self else { return }
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.25) {
                self.gcdButton.center = CGPoint(x: defaultCenter.x + 5, y: defaultCenter.y + 5)
                self.gcdButton.transform = CGAffineTransform(rotationAngle: Double.pi / 40)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25,
                               relativeDuration: 0.25) {
                self.gcdButton.center = defaultCenter
                self.gcdButton.transform = defaultTransform
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5,
                               relativeDuration: 0.25) {
                self.gcdButton.center = CGPoint(x: defaultCenter.x - 5, y: defaultCenter.y - 5)
                
                // Сделал угол поменьше, так как 18 градусов слишком некрасиво, сейчас 4.5
                self.gcdButton.transform = CGAffineTransform(rotationAngle: -Double.pi / 40)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75,
                               relativeDuration: 1) {
                self.gcdButton.center = defaultCenter
                self.gcdButton.transform = defaultTransform
            }
        }
    }
    
    func stopAnimationSaveButton() {
        gcdButton.layer.removeAllAnimations()
        
        guard let tmpTransform = gcdButton.layer.presentation()?.affineTransform(),
              let tmpCenter = gcdButton.layer.presentation()?.frame else {
            return setDefaultsParametersToSaveButton()
        }
        
        gcdButton.transform = tmpTransform
        gcdButton.center = CGPoint(x: tmpCenter.midX, y: tmpCenter.midY)
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.setDefaultsParametersToSaveButton()
        }
    }
    
    private func setDefaultsParametersToSaveButton() {
        guard let defaultCenter = defaultCenter, let defaultTransform = defaultTransform else { return }
        
        self.gcdButton.center = defaultCenter
        self.gcdButton.transform = defaultTransform
    }
}
