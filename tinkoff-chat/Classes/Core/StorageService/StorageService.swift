//
//  BasicCoreDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 08.04.2022.
//

import Foundation
import CoreData

class StorageService: IStorageService {
    func enableObservers(_ context: NSManagedObjectContext) {
        let notification = NotificationCenter.default
        
        notification.addObserver(
            self,
            selector: #selector(contextDidChanged),
            name: .NSManagedObjectContextObjectsDidChange,
            object: context
        )
    }
    
    @objc private func contextDidChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        print("\n-------")
        if let countInserted = (userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>)?.count {
            print("Добавлено записей:", countInserted)
        }
        if let countUpdated = (userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>)?.count {
            print("Изменено записей:", countUpdated)
        }
        if let countDeleted = (userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>)?.count {
            print("Удалено записей:", countDeleted)
        }
        print("-------\n")
    }
    
    func performSave(writeContext context: NSManagedObjectContext, _ block: @escaping (NSManagedObjectContext) -> Void) {
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
    
    func readData<T: NSManagedObject>(readContext context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> [T] {
        let fetchRequest = T.fetchRequest()
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        guard let result = try? context.fetch(fetchRequest) as? [T] else { return [] }
        return result
    }
    
    func deleteData<T: NSManagedObject>(writeContext context: NSManagedObjectContext, model: T) {
        performSave(writeContext: context) { context in
            context.delete(model)
        }
    }
}
