//
//  AvailabilityCell.swift
//  CarePointe
//
//  Created by Brian Bird on 2/3/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class AvailabilityCell: UITableViewCell {

    // table view superclass: AvailabilityViewController
    // identity: availabilitycell
    
    @IBOutlet weak var colorBox: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Columbia-blue thin line [] | [] | [] between cell labels
        colorBox.layer.addBorder(edge: UIRectEdge.left, color: UIColor(hex: 0xA1DCF8), thickness: 0.5)
        colorBox.layer.addBorder(edge: UIRectEdge.right, color: UIColor(hex: 0xA1DCF8), thickness: 0.5)
        //colorBox.layer.borderColor = UIColor(hex: 0xA1DCF8).cgColor //columbia blue
        //colorBox.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
