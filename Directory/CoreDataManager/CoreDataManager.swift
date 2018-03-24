//
//  CoreDataManager.swift
//  Directory
//
//  Created by Abraham Done on 3/23/18.
//  Copyright © 2018 LDS. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataManager {
    static var persistentContainer: NSPersistentContainer!
    static var defaultContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static func createContainer(completion: ((NSPersistentContainer) ->())? = nil) {
        let container = NSPersistentContainer(name: "DirectoryDataModel")
        persistentContainer = container
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Failed to load store:\(String(describing: error))")
            }
            DispatchQueue.main.async {
                completion?(container)
            }
        }
    }
}

protocol Clearable {
    static func clearData(completion: (() -> ())?)
}

protocol Savable {
    func save(completion: (() -> ())?)
}

protocol SavableSingular: Savable {
    static var saved: Self { get }
}

protocol SavableMultiple: Savable {
    static var savedData: [Self] { get }
    var saved: Self { get }
}
