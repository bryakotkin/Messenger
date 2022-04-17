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
        basicService.enableObservers(readContext)
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        basicService.performSave(writeContext: writeContext, block)
    }

    func readData<T: NSManagedObject>(predicate: NSPredicate? = nil, context userContext: NSManagedObjectContext? = nil) -> [T] {
        var context = readContext
        
        if let userContext = userContext {
            context = userContext
        }
        return basicService.readData(readContext: context, predicate: predicate)
    }
    
    func deleteData<T: NSManagedObject>(model: T) {
        basicService.deleteData(writeContext: writeContext, model: model)
    }
}
