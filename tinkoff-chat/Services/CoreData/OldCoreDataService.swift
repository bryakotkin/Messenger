//
//  OldCoreDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 07.04.2022.
//

import CoreData

class OldCoreDataService {
    
    static let shared: OldCoreDataService = OldCoreDataService()
    
    private init() {}
    
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
