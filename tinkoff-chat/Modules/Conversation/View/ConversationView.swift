//
//  ConversationView.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit

protocol ConversationViewDelegate: AnyObject {
    func sendButtonEvent(_ messageText: String)
}

class ConversationView: UIView {
    
    weak var delegate: ConversationViewDelegate?
    
    private var isOverised = false {
        didSet {
            messageTextView.isScrollEnabled = isOverised
            tableView.scrollToBottom(isAnimated: false)
        }
    }
    
    private var maxHeight: CGFloat = UIScreen.main.bounds.width / 2
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationViewCell.self, forCellReuseIdentifier: Constants.conversationCell.rawValue)
        
        return tableView
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 18)
        textView.layer.cornerRadius = 10
        textView.showsHorizontalScrollIndicator = false
        
        return textView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(CustomColors.lightBlue, for: .normal)
        button.setTitleColor(CustomColors.lightBlueAlpha, for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var backgroundViewBottomConstraint: NSLayoutConstraint?
    var messageTextViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.separatorColor = .clear
        sendButton.isEnabled = false
        
        addSubview(tableView)
        addSubview(backgroundView)
        backgroundView.addSubview(messageTextView)
        backgroundView.addSubview(sendButton)
        
        messageTextView.delegate = self
        
        setupButtonAction()
        setupKeyboardObservers()
        updateTheme()
        setupConstraints()
        
        textViewDidChange(messageTextView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtonAction() {
        sendButton.addTarget(self, action: #selector(sendButtonEvent), for: .touchUpInside)
    }
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(keyboardNotification), name: UIWindow.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardNotification), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    private func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        
        backgroundColor = theme?.backgroundColor
        backgroundView.backgroundColor = theme?.backgroundColor
        messageTextView.layer.borderColor = theme?.cloudColorIncoming.cgColor
        messageTextView.layer.borderWidth = 1
        messageTextView.backgroundColor = theme?.cloudColorIncoming.withAlphaComponent(0.8)
        messageTextView.textColor = theme?.labelColorIncomming
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        let tableViewConstraint = [
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.topAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ]
        
        let backgroundViewConstraint = [
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        
        let messageTextViewConstraint = [
            messageTextView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            messageTextView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 10),
            messageTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10),
            messageTextView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10)
        ]
        
        messageTextViewHeightConstraint = messageTextView.heightAnchor.constraint(equalToConstant: 0)
        messageTextViewHeightConstraint?.isActive = true
        
        let sendButtonConstraint = [
            sendButton.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10),
            sendButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            sendButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10)
        ]
        
        backgroundViewBottomConstraint = backgroundView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        backgroundViewBottomConstraint?.isActive = true
        
        sendButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        messageTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        messageTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        sendButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        constraints.append(contentsOf: tableViewConstraint)
        constraints.append(contentsOf: backgroundViewConstraint)
        constraints.append(contentsOf: messageTextViewConstraint)
        constraints.append(contentsOf: sendButtonConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - ConversationView: UITextViewDelegate

extension ConversationView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height < maxHeight {
            let size = CGSize(width: frame.width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)
            messageTextViewHeightConstraint?.constant = estimatedSize.height
            isOverised = false
        } else {
            isOverised = true
        }

        sendButton.isEnabled = !textView.text.isBlank
    }
}

// MARK: - ConversationView: KeyboardNotification

extension ConversationView {
    @objc private func keyboardNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let isKeyboardShowing = notification.name == UIWindow.keyboardWillShowNotification
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        backgroundViewBottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight + safeAreaInsets.bottom : 0
        
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut) { [weak self] in
            self?.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.tableView.scrollToBottom()
        }
    }
}

// MARK: - ConversationView: Button Action

extension ConversationView {
    @objc private func sendButtonEvent() {
        delegate?.sendButtonEvent(messageTextView.text)
        messageTextView.text = ""
        isOverised = false
        messageTextView.contentSize.height = 0
        textViewDidChange(messageTextView)
    }
}
