//
//  setUpInBoxData.swift
//  CarePointe
//
//  Created by Brian Bird on 3/1/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    
    
    func setUpInBoxDataInDefaults() {
        //recipient     title   subject     message     date       time     read
        let inBoxData = [
            ["recipient":"Alice Smith","title":"Nurse","subject":"Patient update 1","message":"Careflows update 1","date":"3/1/17","time":"12:32 PM","isRead":"false"],
            ["recipient":"Brad Smith MD","title":"Primary Doctor","subject":"Patient IDT Update","message":"DISPOSITION Patient profile IDT Update","date":"3/1/17","time":"01:56 PM","isRead":"false"],
            ["recipient":"Dr. Quam","title":"Immunologist","subject":"order blood pressure plate","message":"order blood pressure plate","date":"3/1/17","time":"2:26 PM","isRead":"false"],
            ["recipient":"John Banks","title":"Cardiologist","subject":"Dr D. Webb Telemed update","message":"Dr D. Webb Telemed update","date":"3/1/17","time":"2:55 PM","isRead":"false"],
            ["recipient":"Tammie Summers","title":"Case Manager","subject":"Patient profile Screening update","message":"Patient profile Screening update","date":"3/1/17","time":"4:23 PM","isRead":"false"]
        ]
        
        UserDefaults.standard.set(inBoxData, forKey: "inBoxData")
        UserDefaults.standard.set(inBoxData.count, forKey: "inboxCount")
        UserDefaults.standard.synchronize()
    }
    
}
