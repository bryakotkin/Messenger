//
//  ProfileDataManager.swift
//  tinkoff-chat
//
//  Created by Nikita on 23.03.2022.
//

import Foundation
import UIKit

class ProfileDataManager {
    
    static func saveObjectToFile(_ profile: Profile, flags: ProfileFlags) -> Bool {
        var isSaved = true
        
        do {
            if flags.0 {
                isSaved = try JSONSerialization.save(jsonObject: profile.username, toFilename: Constants.profileUsername.rawValue)
            }
            if flags.1 {
                isSaved = try JSONSerialization.save(jsonObject: profile.description, toFilename: Constants.profileDescription.rawValue)
            }
            if flags.2 {
                isSaved = try JSONSerialization.save(jsonObject: profile.image?.pngData(), toFilename: Constants.profileImage.rawValue)
            }
        }
        catch {
            isSaved = false
        }
        
        return isSaved
    }
    
    static func getObjectFromFile() -> Profile {
        let username: String = (try? JSONSerialization.loadJSON(withFilename: Constants.profileUsername.rawValue, type: String.self)) ?? ""
        let description: String = (try? JSONSerialization.loadJSON(withFilename: Constants.profileDescription.rawValue, type: String.self)) ?? ""
        
        var image: UIImage?
        if let imageData = try? JSONSerialization.loadJSON(withFilename: Constants.profileImage.rawValue, type: Data.self) {
            image = UIImage(data: imageData)
        }
        
        return Profile(username: username, description: description, image: image)
    }
}
