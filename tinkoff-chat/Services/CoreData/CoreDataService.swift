//
//  CoreDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 08.04.2022.
//

import CoreData

protocol CoreDataService {
    func enableObservers()
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    func readData<T: NSManagedObject>() -> [T]
}
