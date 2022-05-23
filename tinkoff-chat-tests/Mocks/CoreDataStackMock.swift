//
//  CoreDataStackMock.swift
//  tinkoff-chat-tests
//
//  Created by Nikita on 22.05.2022.
//

@testable import tinkoff_chat
import CoreData

class CoreDataStaskMock: ICoreDataStack {

    var invokedServiceGetter = false
    var invokedServiceGetterCount = 0
    var stubbedService: ICoreDataService!

    var service: ICoreDataService {
        invokedServiceGetter = true
        invokedServiceGetterCount += 1
        return stubbedService
    }

    var invokedInsertOrUpdateChannel = false
    var invokedInsertOrUpdateChannelCount = 0
    var invokedInsertOrUpdateChannelParameters: (channel: Channel, Void)?
    var invokedInsertOrUpdateChannelParametersList = [(channel: Channel, Void)]()

    func insertOrUpdateChannel(channel: Channel) {
        invokedInsertOrUpdateChannel = true
        invokedInsertOrUpdateChannelCount += 1
        invokedInsertOrUpdateChannelParameters = (channel, ())
        invokedInsertOrUpdateChannelParametersList.append((channel, ()))
    }

    var invokedDeleteChannel = false
    var invokedDeleteChannelCount = 0
    var invokedDeleteChannelParameters: (channel: Channel, Void)?
    var invokedDeleteChannelParametersList = [(channel: Channel, Void)]()

    func deleteChannel(channel: Channel) {
        invokedDeleteChannel = true
        invokedDeleteChannelCount += 1
        invokedDeleteChannelParameters = (channel, ())
        invokedDeleteChannelParametersList.append((channel, ()))
    }

    var invokedInsertMessage = false
    var invokedInsertMessageCount = 0
    var invokedInsertMessageParameters: (dbChannel: DBChannel, message: Message, context: NSManagedObjectContext)?
    var invokedInsertMessageParametersList = [(dbChannel: DBChannel, message: Message, context: NSManagedObjectContext)]()

    func insertMessage(dbChannel: DBChannel, message: Message, context: NSManagedObjectContext) {
        invokedInsertMessage = true
        invokedInsertMessageCount += 1
        invokedInsertMessageParameters = (dbChannel, message, context)
        invokedInsertMessageParametersList.append((dbChannel, message, context))
    }

    var invokedInsertMessages = false
    var invokedInsertMessagesCount = 0
    var invokedInsertMessagesParameters: (channel: Channel, messages: Messages)?
    var invokedInsertMessagesParametersList = [(channel: Channel, messages: Messages)]()

    func insertMessages(channel: Channel, messages: Messages) {
        invokedInsertMessages = true
        invokedInsertMessagesCount += 1
        invokedInsertMessagesParameters = (channel, messages)
        invokedInsertMessagesParametersList.append((channel, messages))
    }
}
