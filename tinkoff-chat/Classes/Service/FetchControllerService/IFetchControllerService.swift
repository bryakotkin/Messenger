//
//  IFetchControllerService.swift
//  tinkoff-chat
//
//  Created by Nikita on 20.04.2022.
//

import UIKit
import CoreData

protocol IFetchControllerService {
    func createFetchController<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) -> NSFetchedResultsController<T>?
}
