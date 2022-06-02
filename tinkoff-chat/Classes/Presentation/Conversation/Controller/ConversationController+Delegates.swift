//
//  ConversationController+Delegates.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import UIKit
import CoreData

// MARK: - ConversationViewController: ConversationViewDelegate, ConversationViewCellDelegate

extension ConversationViewController: ConversationViewDelegate {
    func fetchCurrentTheme() -> Theme? {
        model.fetchCurrentTheme()
    }
    
    func sendButtonEvent(_ messageText: String) {
        model.createMessage(messageText: messageText)
    }
}

// MARK: - ConversationViewController: NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainView?.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainView?.tableView.endUpdates()
        mainView?.tableView.scrollToBottom()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        mainView?.tableView.updateRowsState(
            at: indexPath,
            for: type,
            newIndexPath: newIndexPath
        )
    }
}
