//
//  UITableView+UpdateRowsState.swift
//  tinkoff-chat
//
//  Created by Nikita on 20.04.2022.
//

import UIKit
import CoreData

extension UITableView {
    func updateRowsState(
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            self.insertRows(at: [newIndexPath], with: .none)
        case .delete:
            guard let indexPath = indexPath else { return }

            self.deleteRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }

            self.deleteRows(at: [indexPath], with: .none)
            self.insertRows(at: [newIndexPath], with: .none)
        case .update:
            guard let indexPath = indexPath else { return }

            self.reloadRows(at: [indexPath], with: .none)
        @unknown default:
            return
        }
    }
}
