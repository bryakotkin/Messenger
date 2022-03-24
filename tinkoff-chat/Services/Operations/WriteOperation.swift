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
    
    
    override func main() {
        if profile == nil || flags == nil {
            return
        }
        
//        ProfileDataManager.saveObjectToFile(profile, flags: flags)
    }
}
