//
//  AppointmentCell.swift
//  CarePointe
//
//  Created by Brian Bird on 12/16/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {

    @IBOutlet var time: UILabel!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var task: UILabel!
    @IBOutlet var patient: UILabel!
    @IBOutlet weak var mapButton: RoundedButton!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class addContactCell: UITableViewCell {
    //identifier: addcontactcell
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPosition: UILabel!
    
}
