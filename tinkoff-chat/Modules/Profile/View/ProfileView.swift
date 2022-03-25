//
//  ProfileView.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.02.2022.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    func editButtonAction()
    func saveButtonAction()
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewProtocol?
    
    let userImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .systemYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Marina Dudarenko"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    let userDescription: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        view.text = "UX/UI designer, web-designer, Moscow, Russia"
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(CustomColors.lightBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(CustomColors.lightBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.backgroundColor = CustomColors.lightGrey
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userImageView)
        addSubview(usernameLabel)
        addSubview(userDescription)
        addSubview(editButton)
        addSubview(saveButton)
        
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        
        updateTheme()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        
        usernameLabel.textColor = theme?.labelColor
        userDescription.textColor = theme?.labelColor
        userDescription.backgroundColor = theme?.backgroundColor
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
        
        let usernameLabelConstraint = [
            usernameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            usernameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ]
        
        let userDescriptionConstraint = [
            userDescription.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            userDescription.leftAnchor.constraint(equalTo: leftAnchor, constant: 50),
            userDescription.rightAnchor.constraint(equalTo: rightAnchor, constant: -50)
        ]
        
        let saveButtonConstraint = [
            saveButton.topAnchor.constraint(equalTo: userDescription.bottomAnchor, constant: 20),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalTo: userDescription.widthAnchor),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        let editButtonConstraint = [
            editButton.centerXAnchor.constraint(equalTo: userImageView.rightAnchor),
            editButton.centerYAnchor.constraint(equalTo: userImageView.bottomAnchor)
        ]
        
        constraints.append(contentsOf: usernameLabelConstraint)
        constraints.append(contentsOf: userImageViewConstraint)
        constraints.append(contentsOf: userDescriptionConstraint)
        constraints.append(contentsOf: saveButtonConstraint)
        constraints.append(contentsOf: editButtonConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func editButtonAction() {
        delegate?.editButtonAction()
    }
    
    @objc private func saveButtonAction() {
        delegate?.saveButtonAction()
    }
}
