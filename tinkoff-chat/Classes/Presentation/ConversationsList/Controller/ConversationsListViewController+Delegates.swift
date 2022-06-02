//
//  ConversationsList+Delegates.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import UIKit
import CoreData

// MARK: - ConversationsListViewController: ThemesPickerDelegate

extension ConversationsListViewController: ThemesPickerDelegate {
    func fetchCurrentTheme() -> Theme? {
        model.fetchTheme()
    }
}

// MARK: - ConversationsListViewController: NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainView?.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainView?.tableView.endUpdates()
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

// MARK: - ConversationsListViewController: ConversationsListDelegate

extension ConversationsListViewController: ConversationsListDelegate {
    func fetchChannel(by indexPath: IndexPath) -> Channel? {
        return tableViewDataSource.fetchChannel(by: indexPath)
    }
    
    func cellDidSelected(indexPath: IndexPath, controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
        mainView?.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func removeSwipeActionCompleted(indexPath: IndexPath) {
        self.removeChannelSwipeAction(indexPath)
    }
}
