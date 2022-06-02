//
//  IConversationListModel.swift
//  tinkoff-chat
//
//  Created by Nikita on 21.04.2022.
//

import CoreData

protocol IConversationsListModel {
    func listeningChannels()
    func createChannel(name: String)
    func deleteChannel(channel: Channel)
    func getFetchController() -> NSFetchedResultsController<DBChannel>?
    func saveTheme(_ theme: Theme)
    func fetchTheme() -> Theme?
}
