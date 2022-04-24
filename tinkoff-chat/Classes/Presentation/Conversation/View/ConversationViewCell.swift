//
//  ConversationViewCell.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit

class ConversationViewCell: UITableViewCell {
    
    let cloudView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()
    
    var cloudViewLeftConstraint: NSLayoutConstraint?
    var cloudViewRightConstraint: NSLayoutConstraint?
    var messageLabelTopConstraintToNameLabel: NSLayoutConstraint?
    var nameLabelHeightConstraint: NSLayoutConstraint?
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var isComming = true
    var isBlank = true
    
    func configure(model: Message) {
        message = model.content.isBlank ? "The message disappeared without a trace 🙃" : model.content
        isComming = model.senderId != deviceId
        name = isComming ? model.senderName : ""
        
        isBlank = name?.isBlank ?? true
        nameLabel.isHidden = !isComming
        
        setNeedsUpdateConstraints()
    }
    
    func updateTheme() {
        let theme = ServiceAssembly.themeService.currentTheme
        
        if isComming {
            cloudView.backgroundColor = theme?.cloudColorIncoming
            messageLabel.textColor = theme?.labelColorIncomming
            nameLabel.textColor = theme?.labelColorIncomming
        } else {
            cloudView.backgroundColor = theme?.cloudColor
            messageLabel.textColor = theme?.labelColorOutgoing
            nameLabel.textColor = theme?.labelColorOutgoing
        }
        
        backgroundColor = theme?.backgroundColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        isUserInteractionEnabled = false
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(cloudView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        let nameLabelConstraint = [
            nameLabel.topAnchor.constraint(equalTo: cloudView.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: cloudView.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: cloudView.rightAnchor, constant: -10)
        ]
        
        let messageLabelConstraint = [
            messageLabel.leftAnchor.constraint(equalTo: cloudView.leftAnchor, constant: 10),
            messageLabel.rightAnchor.constraint(equalTo: cloudView.rightAnchor, constant: -10),
            messageLabel.bottomAnchor.constraint(equalTo: cloudView.bottomAnchor, constant: -10)
        ]
        
        let cloudViewConstraint = [
            cloudView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cloudView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            cloudView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 3 / 4, constant: -15)
        ]
        
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        messageLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        cloudViewLeftConstraint = cloudView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15)
        cloudViewRightConstraint = cloudView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15)
        nameLabelHeightConstraint = nameLabel.heightAnchor.constraint(equalToConstant: 0)
        messageLabelTopConstraintToNameLabel = messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor)
        
        messageLabelTopConstraintToNameLabel?.isActive = true
        
        constraints.append(contentsOf: messageLabelConstraint)
        constraints.append(contentsOf: cloudViewConstraint)
        constraints.append(contentsOf: nameLabelConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func updateConstraints() {
        cloudViewLeftConstraint?.isActive = isComming
        cloudViewRightConstraint?.isActive = !isComming
        
        messageLabelTopConstraintToNameLabel?.constant = isBlank ? 0 : 5
        nameLabelHeightConstraint?.isActive = isBlank
        
        super.updateConstraints()
    }
}
