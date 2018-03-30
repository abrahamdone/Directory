//
//  Affiliation.swift
//  Directory
//
//  Created by Abraham Done on 3/22/18.
//  Copyright © 2018 Abraham Done. All rights reserved.
//

import UIKit

enum Affiliation: String, Codable {
    case jedi = "JEDI"
    case resistance = "RESISTANCE"
    case firstOrder = "FIRST_ORDER"
    case sith = "SITH"
    case unknown
    
    // images credit to http://starwars.wikia.com
    var image: UIImage? {
        switch self {
        case .jedi:
            return #imageLiteral(resourceName: "Jedi_symbol")
        case .resistance:
            return #imageLiteral(resourceName: "Resistance_starbird")
        case .firstOrder:
            return #imageLiteral(resourceName: "First_Order")
        case .sith:
            return #imageLiteral(resourceName: "Sith_canon")
        case .unknown:
            return nil
        }
    }
}

extension Affiliation: CustomStringConvertible {
    var description: String {
        switch self {
        case .jedi:
            return NSLocalizedString("AffiliationDescriptionJedi", value: "Jedi", comment: "The name of the Jedi Order")
        case .resistance:
            return NSLocalizedString("AffiliationDescriptionResistance", value: "Resistance", comment: "The name of the Resistance")
        case .firstOrder:
            return NSLocalizedString("AffiliationDescriptionFirstOrder", value: "First Order", comment: "The name of the First Order")
        case .sith:
            return NSLocalizedString("AffiliationDescriptionSith", value: "Sith", comment: "The name of the Sith")
        case .unknown:
            return NSLocalizedString("AffiliationDescriptionUnknown", value: "Unknown", comment: "The affiliation is unknown")
        }
    }
}
