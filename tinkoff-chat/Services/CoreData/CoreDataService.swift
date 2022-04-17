//
//  CoreDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 08.04.2022.
//

import CoreData

protocol CoreDataService {
    func enableObservers(_ context: NSManagedObjectContext)
    func performSave(writeContext: NSManagedObjectContext, _ block: @escaping (NSManagedObjectContext) -> Void)
    func readData<T: NSManagedObject>(readContext: NSManagedObjectContext, predicate: NSPredicate?) -> [T]
    func deleteData<T: NSManagedObject>(writeContext context: NSManagedObjectContext, model: T) 
}
