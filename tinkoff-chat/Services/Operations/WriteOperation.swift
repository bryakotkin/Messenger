//
//  WriteOperation.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.03.2022.
//

import Foundation

class WriteOperation: Operation {
    
    var profile: Profile?
    var flags: ProfileFlags?
    var isSaved = false
    
    override func main() {
        guard let profile = profile, let flags = flags else { return }
        isSaved = ProfileDataManager.saveObjectToFile(profile, flags: flags)
    }
}
