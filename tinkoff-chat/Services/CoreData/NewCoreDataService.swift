//
//  NewCoreDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 08.04.2022.
//

import CoreData

class NewCoreDataService {
    
    let basicService = BasicCoreDataService()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return container
    }()
    
    private lazy var writeContext: NSManagedObjectContext = {
        let context = storeContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    private lazy var readContext: NSManagedObjectContext = {
        let context = storeContainer.viewContext
        return context
    }()
    
    func enableObservers() {
        basicService.enableObservers(writeContext)
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        basicService.performSave(writeContext: writeContext, block)
    }

    func readData<T: NSManagedObject>() -> [T] {
        return basicService.readData(readContext: readContext)
    }
}
