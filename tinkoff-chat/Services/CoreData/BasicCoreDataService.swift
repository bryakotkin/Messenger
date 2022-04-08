//
//  BasicCoreDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 08.04.2022.
//

import Foundation
import CoreData

class BasicCoreDataService: CoreDataService {
    
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
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do {
                    try performSave(in: context)
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
    
    func readData<T: NSManagedObject>(readContext context: NSManagedObjectContext) -> [T] {
        let fetchRequest = T.fetchRequest()
        
        guard let result = try? context.fetch(fetchRequest) as? [T] else { return [] }
        return result
    }
}
