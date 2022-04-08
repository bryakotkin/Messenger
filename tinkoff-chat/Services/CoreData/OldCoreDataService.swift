//
//  OldCoreDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 07.04.2022.
//

import CoreData

class OldCoreDataService {
    
    let basicService = BasicCoreDataService()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Chat", withExtension: "momd"), let model = NSManagedObjectModel(contentsOf: url) else {
            return NSManagedObjectModel()
        }
        return model
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "Chat.sqlite"
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistantStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: persistantStoreURL
            )
        } catch {
            print(error.localizedDescription)
        }
        
        return coordinator
    }()
    
    private lazy var readContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    
    private lazy var writeContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
