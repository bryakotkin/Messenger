//
//  ConversationTableViewDataSource.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import UIKit
import CoreData

class ConversationTableViewDataSource: NSObject, UITableViewDataSource {
    
    var fetchController: NSFetchedResultsController<DBMessage>?
    
    init(frc: NSFetchedResultsController<DBMessage>?) {
        fetchController = frc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.conversationCell.rawValue,
            for: indexPath
        ) as? ConversationViewCell else { return UITableViewCell() }
        
        guard let dbMessage = fetchController?.object(at: indexPath),
              let message = Message(dbModel: dbMessage) else { return UITableViewCell() }
        
        cell.configure(model: message)
        cell.updateTheme()
        
        return cell
    }
}
