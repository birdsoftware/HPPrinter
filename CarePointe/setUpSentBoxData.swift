//
//  setUpSentBoxData.swift
//  CarePointe
//
//  Created by Brian Bird on 3/1/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    
    
    func setUpSentBoxDataInDefaults() {
        //recipient     title   subject     message     date       time
        let sentBoxData = [
            ["recipient":"Alice Smith","title":"Nurse","subject":"Patient update 1","message":"Careflows update 1","date":"3/1/17","time":"12:32 PM"],
            ["recipient":"Brad Smith MD","title":"Primary Doctor","subject":"Patient IDT Update","message":"DISPOSITION Patient profile IDT Update","date":"3/1/17","time":"01:56 PM"]
        ]
        UserDefaults.standard.set(sentBoxData, forKey: "sentData")
        UserDefaults.standard.synchronize()
    }
    
}
