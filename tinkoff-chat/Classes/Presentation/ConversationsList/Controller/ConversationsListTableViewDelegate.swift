//
//  ConversationsListTableViewDelegate.swift
//  tinkoff-chat
//
//  Created by Nikita on 20.04.2022.
//

import UIKit

protocol ConversationsListDelegate: AnyObject {
    func cellDidSelected(indexPath: IndexPath, controller: UIViewController)
    func removeSwipeActionCompleted(indexPath: IndexPath)
    func fetchChannel(by indexPath: IndexPath) -> Channel?
}

class ConversationsListTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var delegate: ConversationsListDelegate?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = delegate?.fetchChannel(by: indexPath) else { return }
        
        let conversationVC = PresentationAssembly.getConversationViewController(channel: model)
        conversationVC.title = model.name
        
        delegate?.cellDidSelected(indexPath: indexPath, controller: conversationVC)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, completionHandler in
            self?.delegate?.removeSwipeActionCompleted(indexPath: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
