//
//  ChannelsViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import UIKit
import CoreData

class ConversationsListTableViewDataSource: NSObject, UITableViewDataSource {
    
    let sectionName = "Channels"
    
    var fetchController: NSFetchedResultsController<DBChannel>?
    
    init(frc: NSFetchedResultsController<DBChannel>?) {
        self.fetchController = frc
    }
    
    // MARK: - Public methods
    
    func fetchChannel(by indexPath: IndexPath) -> Channel? {
        guard let object = fetchController?.object(at: indexPath) else { return nil }
        
        return Channel(dbModel: object)
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchController?.sections else { return 0 }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.conversationCell.rawValue,
            for: indexPath
        ) as? ConversationListCell else { return UITableViewCell() }
        
        guard let channel = fetchChannel(by: indexPath) else { return UITableViewCell() }
        
        cell.configure(model: channel)
        cell.updateTheme()
        
        return cell
    }
}
