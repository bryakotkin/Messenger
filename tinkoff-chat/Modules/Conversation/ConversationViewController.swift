//
//  ConversationViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var messages: Messages?
    
    var mainView: ConversationView? {
        return view as? ConversationView
    }
    
    override func loadView() {
        view = ConversationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView?.tableView.delegate = self
        mainView?.tableView.dataSource = self
    }
}

// MARK: - ConversationViewController: UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    
}

// MARK: - ConversationViewController: UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.conversationCell.rawValue,
            for: indexPath
        ) as? ConversationViewCell else { return UITableViewCell() }
        guard let messages = messages else { return UITableViewCell() }
        
        let message = messages[indexPath.row]
        let model = ConversationCellModel(
            text: message.text,
            isComming: message.isIncoming
        )
        
        cell.configure(model: model)
        cell.updateTheme()
        
        return cell
    }
}
