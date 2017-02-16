//
//  PatientCareTeamCell.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientCareTeamCell: UITableViewCell {
    //PatientCareTeamViewController
    //identifier = patientCareTeamCell
    
    @IBOutlet weak var patientCareTeamStatus: UIImageView!
    @IBOutlet weak var patientCareTeamImage: UIImageView!
    @IBOutlet weak var patientCareTeamName: UILabel!
    @IBOutlet weak var patientCareTeamPosition: UILabel!
    @IBOutlet weak var patientCTVideoButton: UIButton!
    @IBOutlet weak var patientCTCallButton: UIButton!
    @IBOutlet weak var patientCTMessageButton: UIButton!
}
