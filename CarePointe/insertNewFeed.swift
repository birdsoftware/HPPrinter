//
//  insertNewFeed.swift
//  CarePointe
//
//  Created by Brian Bird on 3/17/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func insertPatientFeed(messageCreator: String, message: String, patientID: String, updatedFrom: String, updatedType: String) {
        
        // get current Date and Time
        let currentDate = returnCurrentDateOrCurrentTime(timeOnly: false)
        let currentTime = returnCurrentDateOrCurrentTime(timeOnly: true)
        
        // get curent feed
        var feedData = UserDefaults.standard.object(forKey: "feedData") as? [[String]] ?? [[String]]()
        
        // insert feed                      times       dates       messageCreator  message     patientID
        feedData.insert([currentTime,currentDate,messageCreator,message,patientID,updatedFrom,updatedType], at: 0)
        
        // save
        UserDefaults.standard.set(feedData, forKey: "feedData")
        UserDefaults.standard.synchronize()
    }
    
}
