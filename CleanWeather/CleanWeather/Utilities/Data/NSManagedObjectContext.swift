//
//  NSManagedObjectContext.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }

    @discardableResult
    func saveOrRollback() -> Bool {
        do {
            hasChanges ? try save() : ()
            return true
        } catch let error {
            rollback()
            log.error("SaveOrRollback error: \(String(describing: error.localizedDescription))")
            return false
        }
    }
}
