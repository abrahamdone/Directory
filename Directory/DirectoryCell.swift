//
//  DirectoryCell.swift
//  Directory
//
//  Created by Abraham Done on 3/22/18.
//  Copyright © 2018 Abraham Done. All rights reserved.
//

import UIKit

import AlamofireImage

class DirectoryCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var affiliationImage: UIImageView!
    
    func setup(individual: Individual) {
        name.text = individual.fullName
        affiliationImage.image = individual.affiliation.image
    }
}
