//
//  UITableView.swift
//  TeamView
//
//  Created by Abraham Done on 3/15/18.
//  Copyright © 2018 Abraham Done. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UIView>(_ type: T.Type) {
        self.register(T.nib, forCellReuseIdentifier: T.identifier)
    }
}
