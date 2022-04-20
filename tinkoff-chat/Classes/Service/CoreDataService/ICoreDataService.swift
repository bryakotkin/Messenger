//
//  CoreDataService.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import Foundation
import CoreData

protocol ICoreDataService {
    static var shared: ICoreDataService { get }
    
    var storageService: IStorageService { get set }
    var readContext: NSManagedObjectContext { get }
    var writeContext: NSManagedObjectContext { get }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    func readData<T: NSManagedObject>(predicate: NSPredicate?, context userContext: NSManagedObjectContext?) -> [T]
    func deleteData<T: NSManagedObject>(model: T)
}
