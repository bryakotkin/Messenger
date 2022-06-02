//
//  ConversationsListCell.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit

protocol ConversationListCellDelegate: AnyObject {
    func fetchCurrentTheme() -> Theme?
}

class ConversationListCell: UITableViewCell {
    
    weak var delegate: ConversationListCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18)
        label.textColor = CustomColors.lightGrey3
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
            if let date = date {
                if Calendar.current.isDateInToday(date) {
                    dateFormatter.dateFormat = "HH:mm"
                } else {
                    dateFormatter.dateFormat = "dd/MM/YYYY"
                }
                
                let dateString = dateFormatter.string(from: date)
                dateLabel.text = dateString
            } else {
                dateLabel.text = ""
            }
        }
    }
    
    var message: String? {
        didSet {
            if let message = message {
                messageLabel.text = message
            } else {
                messageLabel.font = UIFont(name: "Helvetica Neue", size: 18)
                messageLabel.text = "Not message yet."
                hasUnreadMessages = false
            }
        }
    }
    
    var isOnline: Bool?
    
    var hasUnreadMessages: Bool? {
        didSet {
            if let hasUnreadMessages = hasUnreadMessages, hasUnreadMessages {
                messageLabel.font = .systemFont(ofSize: 18, weight: .bold)
            } else {
                messageLabel.font = .systemFont(ofSize: 18)
            }
        }
    }
    
    func configure(model: Channel) {
        title = model.name
        message = model.lastMessage
        date = model.lastActivity
    }
    
    func updateTheme() {
        let theme = delegate?.fetchCurrentTheme()
        let isOnline: Bool = isOnline ?? false
        let labelColor = isOnline ? theme?.labelColorOnline : theme?.labelColor
        
        titleLabel.textColor = labelColor
        dateLabel.textColor = labelColor
        messageLabel.textColor = labelColor
        backgroundColor = isOnline ? theme?.backgroundColorOnline : theme?.backgroundColor
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []

        let titleLabelConstraint = [
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.rightAnchor.constraint(equalTo: dateLabel.leftAnchor, constant: -5)
        ]
        
        let dateLabelConstraint = [
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            dateLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -5)
        ]
        
        let messageLabelConstraint = [
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            messageLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            messageLabel.rightAnchor.constraint(equalTo: dateLabel.rightAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ]
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        dateLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        messageLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        constraints.append(contentsOf: titleLabelConstraint)
        constraints.append(contentsOf: dateLabelConstraint)
        constraints.append(contentsOf: messageLabelConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
}
