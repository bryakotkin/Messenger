//
//  ReadOperation.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.03.2022.
//

import Foundation

class ReadOperation: Operation {
    
    var profile = Profile(username: "", description: "", image: nil)
    
    override func main() {
        profile = ProfileDataManager.getObjectFromFile()
    }
}
