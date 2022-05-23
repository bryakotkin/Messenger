//
//  ChannelFirebaseServiceTests.swift
//  tinkoff-chat-tests
//
//  Created by Nikita on 22.05.2022.
//

import XCTest
@testable import tinkoff_chat

class ChannelFirebaseServiceTests: XCTestCase {
    
    var coreDataStackMock: CoreDataStaskMock!
    var firebaseServiceMock: FirebaseServiceMock!
    var channelService: IChannelFirebaseService!
    
    override func setUp() {
        super.setUp()
        
        coreDataStackMock = CoreDataStaskMock()
        firebaseServiceMock = FirebaseServiceMock()
        
        channelService = build()
    }
    
    func testCreateChannel() {
        // Arrange
        let channelName = "Rocket channel"
        
        // Act
        channelService?.createChannel(name: channelName)
        
        guard let resultChannelName = firebaseServiceMock.invokedAddDocumentParameters?.0["name"] as? String else {
            return XCTFail("Invoked channel name is nil")
        }
        
        // Assert
        XCTAssertTrue(firebaseServiceMock.invokedAddDocument, "Not called add document method")
        XCTAssertEqual(resultChannelName, channelName)
    }
    
    func testDeleteChannel() {
        // Arrange
        let channel = Channel(identifier: "i1",
                              name: "Rocket channel",
                              lastMessage: nil,
                              lastActivity: nil)
        
        // Act
        channelService?.deleteChannel(channel: channel)
        
        guard let channelIdentifier = firebaseServiceMock.invokedDeleteDocumentParameters?.0 else {
            return XCTFail("Invoked channel identifier is nil")
        }
        
        // Assert
        XCTAssertTrue(firebaseServiceMock.invokedDeleteDocument, "Not called delete document method")
        XCTAssertEqual(channel.identifier, channelIdentifier)
    }
    
    func build() -> IChannelFirebaseService {
        return ChannelFirebaseService(coreDataStack: coreDataStackMock,
                                      firebaseService: firebaseServiceMock)
    }
}
