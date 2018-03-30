//
//  Managed.swift
//  Directory
//
//  Created by Abraham Done on 3/23/18.
//  Copyright © 2018 LDS. All rights reserved.
//

import Foundation
import CoreData

protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultFetch: NSFetchRequest<Self> { get }
    static func clearData(completion: (() -> ())?)
}

protocol ManagedSingular: Managed {
    static var managedObject: Self { get }
}

extension ManagedSingular {
    static func clearData(completion: (() -> ())? = nil) {
        CoreDataManager.defaultContext.makeChanges {
            completion?()
            CoreDataManager.defaultContext.delete(self.managedObject as! NSManagedObject)
        }
    }
    
    static var defaultFetch: NSFetchRequest<Self> {
        return fetchSingle
    }
    
    static var fetchSingle: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.fetchBatchSize = 1
        return request
    }
}

protocol ManagedMultiple: Managed {
    var primaryKey: String? { get set }
    static var managedObjects: [Self] { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    static func getDataPoint(with uuid: UUID) -> Self
}

extension ManagedMultiple {
    static func clearData(completion: (() -> ())? = nil) {
        CoreDataManager.defaultContext.makeChanges {
            managedObjects.forEach { data in
                CoreDataManager.defaultContext.delete(data as! NSManagedObject)
            }
            completion?()
        }
    }
    
    static var defaultFetch: NSFetchRequest<Self> {
        return sortedFetchRequest
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}
