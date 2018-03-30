//
//  Individual.swift
//  Directory
//
//  Created by Abraham Done on 3/22/18.
//  Copyright © 2018 Abraham Done. All rights reserved.
//

import Foundation
import CoreData

enum IndividualError: Error {
    case badDate
    case badPicture
    case unknownAffiliation
}

struct Individual: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let forceSensitive: Bool
    let birthdate: Date
    let profilePictureUrl: URL?
    let affiliation: Affiliation
    
    var fullName: String {
        if !lastName.isEmpty {
            return "\(firstName) \(lastName)"
        } else {
            return firstName
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case profilePictureUrlString = "profilePicture"
        case affiliationString = "affiliation"
        case birthdateString = "birthdate"
        case id, firstName, lastName, forceSensitive
    }
    
    fileprivate init(data: IndividualMO) {
        self.id = Int(data.id)
        self.firstName = data.firstName
        self.lastName = data.lastName
        self.forceSensitive = data.forceSensitive
        self.birthdate = data.birthdate
        if let string = data.profilePictureUrlString {
            self.profilePictureUrl = URL(string: string)
        } else {
            self.profilePictureUrl = nil
        }
        self.affiliation = Affiliation(rawValue: data.affiliationString) ?? .unknown
    }
    
    init(from decoder: Decoder) throws {
        let coderValues = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try coderValues.decode(Int.self, forKey: .id)
        firstName = try coderValues.decode(String.self, forKey: .firstName)
        lastName = try coderValues.decode(String.self, forKey: .lastName)
        forceSensitive = try coderValues.decode(Bool.self, forKey: .forceSensitive)
        
        let birthdateString = try coderValues.decode(String.self, forKey: .birthdateString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: birthdateString) else {
            throw IndividualError.badDate
        }
        
        birthdate = date
        
        let profilePictureUrlString = try coderValues.decode(String.self, forKey: .profilePictureUrlString)
        guard let url = URL(string: profilePictureUrlString) else {
            throw IndividualError.badPicture
        }
        
        profilePictureUrl = url
        
        let affiliationString = try coderValues.decode(String.self, forKey: .affiliationString)
        affiliation = Affiliation(rawValue: affiliationString) ?? .unknown
        self.save()
    }
}

extension Individual: Savable {
    static var savedData: [Individual] {
        return IndividualMO.managedObjects.map { $0.dataObject }
    }
    
    func save(completion: (() -> ())? = nil) {
        CoreDataManager.defaultContext.makeChanges {
            IndividualMO.getDataPoint(withId: Int64(self.id)).replace(with: self)
            completion?()
        }
    }
}

@objc(IndividualMO)
final fileprivate class IndividualMO: NSManagedObject, Managed {
    static var entityName: String = "IndividualMO"
    
    @NSManaged var affiliationString: String
    @NSManaged var birthdate: Date
    @NSManaged var firstName: String
    @NSManaged var forceSensitive: Bool
    @NSManaged var id: Int64
    @NSManaged var lastName: String
    @NSManaged var profilePictureUrlString: String?
    
    func replace(with data: Individual) {
        self.affiliationString = data.affiliation.rawValue
        self.birthdate = data.birthdate
        self.firstName = data.firstName
        self.forceSensitive = data.forceSensitive
        self.id = Int64(data.id)
        self.lastName = data.lastName
        self.profilePictureUrlString = data.profilePictureUrl?.absoluteString
    }
    
    var dataObject: Individual {
        return Individual(data: self)
    }
    
    static var managedObjects: [IndividualMO] {
        let request = defaultFetch
        if let dataPoints = try? CoreDataManager.defaultContext.fetch(request), dataPoints.count > 0 {
            return dataPoints
        } else {
            return []
        }
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(IndividualMO.id), ascending: true)]
    }
    
    static func getDataPoint(withId id: Int64) -> IndividualMO {
        let context = CoreDataManager.defaultContext
        let request = defaultFetch
        request.predicate = NSPredicate(format: "%K == %ld", #keyPath(IndividualMO.id), id)
        if let dataPoints = try? context.fetch(request), dataPoints.count == 1 {
            return dataPoints.first!
        } else {
            let new: IndividualMO = context.insertObject()
            new.id = id
            return new
        }
    }
    
    static var defaultFetch: NSFetchRequest<IndividualMO> {
        return NSFetchRequest<IndividualMO>(entityName: entityName)
    }
    
    static func clearData(completion: (() -> ())?) {
        CoreDataManager.defaultContext.makeChanges {
            managedObjects.forEach { data in
                CoreDataManager.defaultContext.delete(data)
            }
            completion?()
        }
    }
}
