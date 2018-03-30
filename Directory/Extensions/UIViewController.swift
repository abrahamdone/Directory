//
//  UIViewController.swift
//  TeamView
//
//  Created by Abraham Done on 3/15/18.
//  Copyright © 2018 Abraham Done. All rights reserved.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    
    var identifier: String {
        return String(describing: type(of: self))
    }
}
