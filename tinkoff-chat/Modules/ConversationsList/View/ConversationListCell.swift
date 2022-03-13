//
//  ConversationsListCell.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit

class ConversationListCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18)
        label.textColor = .fromHex(hex: 0x3C3C43, alpha: 0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        return formatter
    }()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var date: Date? {
        didSet {
            guard let date = date else { return }
            
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "HH:mm"
            }
            else {
                dateFormatter.dateFormat = "dd/MM/YYYY"
            }
            
            let dateString = dateFormatter.string(from: date)
            dateLabel.text = dateString
        }
    }
    
    var message: String? {
        didSet {
            if let message = message {
                messageLabel.text = message
            }
            else {
                messageLabel.font = UIFont(name: "Helvetica Neue", size: 18)
                messageLabel.text = "Not message yet."
                hasUnreadMessages = false
            }
        }
    }
    
    var isOnline: Bool? {
        didSet {
            if let isOnline = isOnline, isOnline {
                backgroundColor = .fromHex(hex: 0xFFFACF)
            }
            else {
                backgroundColor = .systemBackground
            }
        }
    }
    
    var hasUnreadMessages: Bool? {
        didSet {
            if let hasUnreadMessages = hasUnreadMessages, hasUnreadMessages {
                messageLabel.font = .systemFont(ofSize: 18, weight: .bold)
            } else {
                messageLabel.font = .systemFont(ofSize: 18)
            }
        }
    }
    
    func configure(model: ConversationListCellModel) {
        hasUnreadMessages = model.hasUnreadMessages
        title = model.name
        message = model.message
        date = model.date
        isOnline = model.online
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []

        let titleLabelConstraint = [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            titleLabel.rightAnchor.constraint(equalTo: dateLabel.leftAnchor)
        ]
        
        let dateLabelConstraint = [
            dateLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
        ]
        
        let messageLabelConstraint = [
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            messageLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            messageLabel.rightAnchor.constraint(equalTo: dateLabel.rightAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ]
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        messageLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        constraints.append(contentsOf: titleLabelConstraint)
        constraints.append(contentsOf: dateLabelConstraint)
        constraints.append(contentsOf: messageLabelConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
}

