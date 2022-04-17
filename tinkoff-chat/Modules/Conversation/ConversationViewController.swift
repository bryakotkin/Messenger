//
//  ConversationViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    
    var channel: Channel?
    let firebaseManager = (UIApplication.shared.delegate as? AppDelegate)?.firebaseManager
    
    lazy var fetchController: NSFetchedResultsController<DBMessage> = {
        let context = CoreDataStack.shared.service.readContext
        
        let fetchRequest = DBMessage.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(DBMessage.created), ascending: true)
        ]
        
        let format = #keyPath(DBMessage.channel.identifier) + " == %@"
        let predicate = NSPredicate(format: format, self.channel?.identifier ?? "")
        fetchRequest.predicate = predicate
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            print("Fetch Controller error:", error.localizedDescription)
        }
        
        return controller
    }()
    
    var mainView: ConversationView? {
        return view as? ConversationView
    }
    
    // MARK: - Overridden methods
    
    override func loadView() {
        view = ConversationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        firebaseManager?.listeningMessages(channel: channel)
        
        mainView?.tableView.dataSource = self
        mainView?.delegate = self
    }
}

// MARK: - ConversationViewController: UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.conversationCell.rawValue,
            for: indexPath
        ) as? ConversationViewCell else { return UITableViewCell() }
        
        let dbMessage = fetchController.object(at: indexPath)
        guard let message = Message(dbModel: dbMessage) else { return UITableViewCell() }
        
        cell.configure(model: message)
        cell.updateTheme()
        
        return cell
    }
}

// MARK: - ConversationViewController: ConversationViewDelegate

extension ConversationViewController: ConversationViewDelegate {
    func sendButtonEvent(_ messageText: String) {
        guard let channel = channel else { return }
        firebaseManager?.createMessage(channel: channel, messageText)
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
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }

            mainView?.tableView.insertRows(at: [newIndexPath], with: .none)
        case .delete:
            guard let indexPath = indexPath else { return }

            mainView?.tableView.deleteRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }

            mainView?.tableView.deleteRows(at: [indexPath], with: .none)
            mainView?.tableView.insertRows(at: [newIndexPath], with: .none)
        case .update:
            guard let indexPath = indexPath else { return }

            mainView?.tableView.reloadRows(at: [indexPath], with: .none)
        @unknown default:
            return
        }
    }
}
