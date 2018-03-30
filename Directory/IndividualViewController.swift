//
//  IndividualViewController.swift
//  Directory
//
//  Created by Abraham Done on 3/22/18.
//  Copyright © 2018 Abraham Done. All rights reserved.
//

import UIKit

import AlamofireImage

class IndividualViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var affiliationPicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var forceSensitiveLabel: UILabel!
    
    var individual: Individual?
}

// MARK: View life cycle
extension IndividualViewController {
    override func viewWillAppear(_ animated: Bool) {
        guard let individual = individual else {
            return
        }
        
        if let url = individual.profilePictureUrl {
            profilePicture.af_setImage(withURL: url)
        } else {
            profilePicture.backgroundColor = .lightGray
        }
        
        affiliationPicture.image = individual.affiliation.image
        nameLabel.text = "\(individual.affiliation) \(individual.fullName)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let date = dateFormatter.string(from: individual.birthdate)
        birthdateLabel.text = String.localizedStringWithFormat(NSLocalizedString("IndividualViewControllerBirth", value: "Birth: %@", comment: "The date of the individual's birth"), date)
        if individual.forceSensitive {
            forceSensitiveLabel.text = NSLocalizedString("IndividualViewControllerForceSensitive", value: "Can sense the force.", comment: "The individual can feel the force and act upon it")
        } else {
            forceSensitiveLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = individual?.fullName
    }
}
