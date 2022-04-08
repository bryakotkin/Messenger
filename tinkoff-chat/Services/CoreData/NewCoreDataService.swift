//
//  NewCoreDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 08.04.2022.
//

import CoreData

class NewCoreDataService: CoreDataService {
    
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
        let notification = NotificationCenter.default
        
        notification.addObserver(
            self,
            selector: #selector(contextDidChanged),
            name: .NSManagedObjectContextObjectsDidChange,
            object: writeContext
        )
    }
    
    @objc func contextDidChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let countInserted = (userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>)?.count {
            print("Добавлено записей:", countInserted)
        }
        if let countUpdated = (userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>)?.count {
            print("Изменено записей:", countUpdated)
        }
        if let countDeleted = (userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>)?.count {
            print("Удалено записей:", countDeleted)
        }
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = writeContext
        
        context.performAndWait { [weak self] in
            block(context)
            if context.hasChanges {
                do {
                    try self?.performSave(in: context)
                } catch {
                    context.rollback()
                    print("No data saved:", error.localizedDescription)
                }
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        if let parent = context.parent { try performSave(in: parent) }
    }
    
    func readData<T: NSManagedObject>() -> [T] {
        let fetchRequest = T.fetchRequest()
        let context = readContext
        
        guard let result = try? context.fetch(fetchRequest) as? [T] else { return [] }
        return result
    }
}
