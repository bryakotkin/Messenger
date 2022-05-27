//
//  tinkoff_chat_UITests.swift
//  tinkoff-chat-UITests
//
//  Created by Nikita on 23.05.2022.
//

import XCTest

class ProfileUITests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }
    
    func testProfile() {
        // Arrange
        let app = XCUIApplication()
        
        // Act
        app.launch()
        app.navigationBars["Tinkoff Chat"].buttons["person"].tap()
        
        let userImageView = app.images["userImageView"]
        let usernameTextField = app.textFields["usernameTextField"]
        let editImageButton = app.buttons["editImageButton"]
        let titleBar = app.navigationBars["My Profile"]
        let editButton = app.buttons["editButton"]
        let descriptiontextviewTextView = app.textViews["descriptionTextView"]
        let cancelViewButton = app.navigationBars["My Profile"].buttons["Cancel"]
        
        XCTAssertTrue(titleBar.exists)
        XCTAssertTrue(userImageView.exists)
        XCTAssertTrue(usernameTextField.exists)
        XCTAssertTrue(editImageButton.exists)
        XCTAssertTrue(editButton.exists)
        XCTAssertTrue(descriptiontextviewTextView.exists)
        XCTAssertTrue(cancelViewButton.exists)
        
        editButton.tap()
        
        let cancelButton = app.buttons["cancelButton"]
        let gcdButton = app.buttons["gcdButton"]
        
        XCTAssertTrue(cancelButton.exists)
        XCTAssertTrue(gcdButton.exists)
    }
}
