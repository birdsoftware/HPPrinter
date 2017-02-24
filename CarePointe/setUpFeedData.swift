//
//  setUpFeedData.swift
//  CarePointe
//
//  Created by Brian Bird on 2/23/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    
    
    func setUpFeedDataInDefaults() {
        //times     dates   messageCreator  message     patientID
        let feedData = [
                        ["12:32 AM","2/22/17","Steph Smith","Careflows update 1 some more descrption text would go here","12345"],
                        ["01:56 PM","2/21/17","Victor Owen","Patient profile Update some more descrption text would go here","12345"],
                        ["03:22 PM","2/21/17","John Banks","Patient was not ready for coverage","12345"],
                        ["11:12 AM","2/20/17","Steph Smith","DISPOSITION Patient profile IDT","12345"],
                        ["10:52AM","2/18/17","Elida Martinez","Patient medication some more descrption text","12345"]
        ]

        UserDefaults.standard.set(feedData, forKey: "feedData")
        UserDefaults.standard.synchronize()
    }
}