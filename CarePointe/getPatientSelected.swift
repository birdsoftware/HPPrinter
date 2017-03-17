//
//  getPatientSelected.swift
//  CarePointe
//
//  Created by Brian Bird on 3/17/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func returnSelectedPatientID() -> String{

        let selectedRow = UserDefaults.standard.integer(forKey: "selectedRow")      // "selectedRowMainDashBoard"
        let sectionForSelectedRow = UserDefaults.standard.integer(forKey: "sectionForSelectedRow")

        // get curent feed
        let patientIDData = UserDefaults.standard.object(forKey: "patientID") as? [[String]] ?? [[String]]()
        
        let currentPatientID = patientIDData[sectionForSelectedRow][selectedRow]
        
        return currentPatientID
    }

}
