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
    func operationButtonAction()
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewProtocol?
    
    let userImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = CustomColors.lightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let usernameTextField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 24, weight: .bold)
        field.placeholder = "ФИО"
        field.clearButtonMode = .whileEditing
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()

    let descriptionTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let editImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(CustomColors.lightBlue, for: .normal)
        button.setTitleColor(CustomColors.lightBlueAlpha, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        return button
    }()
    
    let gcdButton: UIButton = {
        let button = UIButton()
        button.setTitle("GCD", for: .normal)
        button.setTitleColor(CustomColors.lightBlue, for: .normal)
        button.setTitleColor(CustomColors.lightBlueAlpha, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.backgroundColor = CustomColors.lightGrey
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    let operationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Operation", for: .normal)
        button.setTitleColor(CustomColors.lightBlue, for: .normal)
        button.setTitleColor(CustomColors.lightBlueAlpha, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.backgroundColor = CustomColors.lightGrey
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        
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
        addSubview(operationButton)
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
        operationButton.addTarget(self, action: #selector(operationButtonAction), for: .touchUpInside)
    }
    
    private func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        
        usernameTextField.textColor = theme?.labelColor
        
        if let placeHolderColor = theme?.labelColor {
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "ФИО", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor.withAlphaComponent(0.5)])
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
            userImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/3),
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
            gcdButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1/2, constant: -5),
            gcdButton.leftAnchor.constraint(equalTo: cancelButton.leftAnchor),
            gcdButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 10),
            gcdButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        let operationButtonConstraint = [
            operationButton.rightAnchor.constraint(equalTo: cancelButton.rightAnchor),
            operationButton.widthAnchor.constraint(equalTo: gcdButton.widthAnchor),
            operationButton.bottomAnchor.constraint(equalTo: gcdButton.bottomAnchor),
            operationButton.topAnchor.constraint(equalTo: gcdButton.topAnchor)
        ]
        
        constraints.append(contentsOf: usernameTextFieldConstraint)
        constraints.append(contentsOf: userImageViewConstraint)
        constraints.append(contentsOf: activityIndicatorConstraint)
        constraints.append(contentsOf: descriptionConstraint)
        constraints.append(contentsOf: editButtonConstraint)
        constraints.append(contentsOf: editImageButtonConstraint)
        constraints.append(contentsOf: cancelButtonConstraint)
        constraints.append(contentsOf: gcdButtonConstraint)
        constraints.append(contentsOf: operationButtonConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func editImageButtonAction() {
        delegate?.editImageButtonAction()
    }
    
    @objc private func editButtonAction() {
        delegate?.editButtonAction()
    }
    
    @objc private func cancelButtonAction() {
        delegate?.cancelButtonAction()
    }
    
    @objc private func gcdButtonAction() {
        delegate?.gcdButtonAction()
    }
    
    @objc private func operationButtonAction() {
        delegate?.operationButtonAction()
    }
}
