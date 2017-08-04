//
//  caseCell.swift
//  CarePointe
//
//  Created by Brian Bird on 3/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class caseCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var details: UILabel!

}

class clinicalCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var details: UILabel!
    
}

//services

class servicesCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var details2: UILabel!
    
    
}

class locationsCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var details2: UILabel!
    
    
}

class edcell: UITableViewCell {
    
    @IBOutlet weak var facility: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var chiefComplaint: UILabel!
    
    
}
