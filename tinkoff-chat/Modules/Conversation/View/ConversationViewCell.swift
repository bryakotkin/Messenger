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
        view.layer.cornerRadius = 15
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
    
    var cloudViewLeftConstraint: NSLayoutConstraint?
    var cloudViewRightConstraint: NSLayoutConstraint?
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    var isComming: Bool?
    
    func configure(model: ConversationCellModel) {
        message = model.text
        isComming = model.isComming
    }
    
    func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        
        if let isComming = isComming, !isComming {
            cloudView.backgroundColor = theme?.cloudColor
            messageLabel.textColor = theme?.labelColorOutgoing
            cloudViewRightConstraint?.isActive = true
        }
        else {
            cloudView.backgroundColor = theme?.cloudColorIncoming
            messageLabel.textColor = theme?.labelColorIncomming
            cloudViewLeftConstraint?.isActive = true
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
        addSubview(cloudView)
        addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        let messageLabelConstraint = [
            messageLabel.leftAnchor.constraint(equalTo: cloudView.leftAnchor, constant: 10),
            messageLabel.rightAnchor.constraint(equalTo: cloudView.rightAnchor, constant: -10),
            messageLabel.topAnchor.constraint(equalTo: cloudView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: cloudView.bottomAnchor, constant: -10)
        ]
        
        let cloudViewConstraint = [
            cloudView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cloudView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            cloudView.heightAnchor.constraint(equalTo: messageLabel.heightAnchor, constant: 20),
            cloudView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 3/4, constant: -20)
        ]
        
        messageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        cloudView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        cloudViewLeftConstraint = cloudView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15)
        cloudViewRightConstraint = cloudView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
        
        constraints.append(contentsOf: messageLabelConstraint)
        constraints.append(contentsOf: cloudViewConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
}
