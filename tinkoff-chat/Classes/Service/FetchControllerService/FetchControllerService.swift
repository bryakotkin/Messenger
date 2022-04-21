//
//  FetchControllerService.swift
//  tinkoff-chat
//
//  Created by Nikita on 20.04.2022.
//

import CoreData
import UIKit

class FetchContollerService: IFetchControllerService {
    func createFetchController<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) -> NSFetchedResultsController<T>? {
        let coreDataStack = ServiceAssembly.coreDataStack
        let context = coreDataStack.service.readContext
        
        let fetchRequest = T.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        ) as? NSFetchedResultsController<T>
        
        return controller
    }
}
