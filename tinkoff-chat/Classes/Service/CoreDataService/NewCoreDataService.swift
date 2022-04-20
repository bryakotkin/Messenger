//
//  NewCoreDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 08.04.2022.
//

import CoreData

class NewCoreDataService: ICoreDataService {
    
    static var shared: ICoreDataService = NewCoreDataService()
    
    var storageService = CoreAssembly.storageService
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return container
    }()
    
    lazy var readContext: NSManagedObjectContext = {
        let context = storeContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    lazy var writeContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = readContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    func enableObservers() {
        storageService.enableObservers(readContext)
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        storageService.performSave(writeContext: writeContext, block)
    }

    func readData<T: NSManagedObject>(predicate: NSPredicate? = nil, context userContext: NSManagedObjectContext? = nil) -> [T] {
        var context = readContext
        
        if let userContext = userContext {
            context = userContext
        }
        return storageService.readData(readContext: context, predicate: predicate)
    }
    
    func deleteData<T: NSManagedObject>(model: T) {
        storageService.deleteData(writeContext: writeContext, model: model)
    }
}
