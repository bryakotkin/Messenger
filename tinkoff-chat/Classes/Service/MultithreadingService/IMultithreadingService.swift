//
//  MultithreadingManager.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.03.2022.
//

import Foundation

protocol IMultithreadingService {
    func saveData(_ profile: Profile, flags: ProfileFlags, completionHandler: @escaping (Bool) -> Void)
    func getData(completionHandler: @escaping (Profile) -> Void) 
}
