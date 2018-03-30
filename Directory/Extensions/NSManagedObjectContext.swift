//
//  NSManagedObjectContext.swift
//  Directory
//
//  Created by Abraham Done on 3/23/18.
//  Copyright © 2018 LDS. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func managedObject<A: NSManagedObject>() -> A where A: ManagedSingular {
        defer {
            _ = saveOrRollback()
        }
        
        let dataPoints = try? fetch(A.defaultFetch)
        if dataPoints?.count == 0 {
            return insertObject()
        }
        
        guard dataPoints?.count == 1 else {
            fatalError("There should be only one \(A.entityName)")
        }
        
        return dataPoints!.first!
    }
    
    func managedObjects<A: NSManagedObject>(withPredicate predicate: NSPredicate? = nil) -> [A] where A: ManagedMultiple {
        let request = A.defaultFetch
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        if let dataPoints = try? fetch(request), dataPoints.count > 0 {
            return dataPoints
        } else {
            return []
        }
    }
    
    func managedObject<A: NSManagedObject>(withKey uuid: UUID) -> A where A: ManagedMultiple {
        let request = A.defaultFetch
        request.predicate = NSPredicate(format: "primaryKey == %@", uuid.uuidString)
        
        if let dataPoints = try? fetch(request), dataPoints.count == 1 {
            return dataPoints.first!
        } else {
            let newObject: A = insertObject()
            newObject.primaryKey = uuid.uuidString
            return newObject
        }
    }
    
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type")
        }
        
        return obj
    }
    
    fileprivate func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    func makeChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}
