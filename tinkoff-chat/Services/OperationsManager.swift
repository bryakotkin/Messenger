//
//  OperationsManager.swift
//  tinkoff-chat
//
//  Created by Nikita on 24.03.2022.
//

import Foundation

class OperationsManager: MultithreadingManager {
    func saveData(_ profile: Profile, flags: ProfileFlags, completionHandler: @escaping (Bool) -> ()) {
        let operationQueue = OperationQueue()
        let operation = WriteOperation()
        operation.profile = profile
        operation.flags = flags
        operation.qualityOfService = .userInteractive
        
        operation.completionBlock = {
            OperationQueue.main.addOperation {
                completionHandler(operation.isSaved)
            }
        }
        
        operationQueue.addOperation(operation)
    }
    
    func getData(completionHandler: @escaping (Profile) -> ()) {
        let operationQueue = OperationQueue()
        let operation = ReadOperation()
        operation.qualityOfService = .userInteractive
        
        operation.completionBlock = {
            OperationQueue.main.addOperation {
                completionHandler(operation.profile)
            }
        }
        
        operationQueue.addOperation(operation)
    }
}
