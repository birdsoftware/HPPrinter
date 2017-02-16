//
//  ScreeningsCell.swift
//  CarePointe
//
//  Created by Brian Bird on 2/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class ScreeningsCell: UITableViewCell {
    // VC class: PatientScreeningsViewController
    // identifier: screeningscell

    @IBOutlet weak var screeningName: UILabel!
    @IBOutlet weak var screeningDate: UILabel!
    @IBOutlet weak var screeningStatus: UILabel!
    //@IBOutlet weak var viewScreeningButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //viewScreeningButton.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
