//
//  UIView.swift
//  TeamView
//
//  Created by Abraham Done on 3/15/18.
//  Copyright © 2018 Abraham Done. All rights reserved.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    @IBInspectable var cornerRadius:CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        } get {
            return self.layer.cornerRadius
        }
    }
}
