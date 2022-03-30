//
//  ConversationViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var channel: Channel? {
        didSet {
            fetchMessages()
        }
    }

    var messages: Messages = []
    let firebaseManager = (UIApplication.shared.delegate as? AppDelegate)?.firebaseManager
    
    var mainView: ConversationView? {
        return view as? ConversationView
    }
    
    override func loadView() {
        view = ConversationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        mainView?.tableView.dataSource = self
        mainView?.delegate = self
    }
}

// MARK: - Firebase logic

extension ConversationViewController {
    func fetchMessages() {
        guard let channel = channel else { return }
        firebaseManager?.listeningMessages(channel: channel) { [weak self] messages in
            self?.messages = messages
            self?.mainView?.tableView.reloadData()
            self?.mainView?.tableView.scrollToBottom(isAnimated: false)
        }
    }
}

// MARK: - ConversationViewController: UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.conversationCell.rawValue,
            for: indexPath
        ) as? ConversationViewCell else { return UITableViewCell() }
        
        let message = messages[indexPath.row]
        cell.configure(model: message)
        cell.updateTheme()
        
        return cell
    }
}

extension ConversationViewController: ConversationViewDelegate {
    func sendButtonEvent(_ messageText: String) {
        guard let channel = channel else { return }
        firebaseManager?.createMessage(channel: channel, messageText)
    }
}
