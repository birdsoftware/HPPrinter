//
//  setupAlertData.swift
//  CarePointe
//
//  Created by Brian Bird on 2/23/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func setUpAlertDataInDefaults() {
        
        //class data
        let alertData = [["","",""]]/*[
            ["Ruth Quinones","01/22/17 12:32AM","Careflows update 1 some more descrption text would go here"],
            ["Ruth Quinones","01/23/17 01:56PM","DISPOSITION Patient profile IDT Update some more descrption text would go here"],
            ["Barrie Thomson","01/23/17 03:22PM","Patient profile Update some more descrption text would go here"],
            ["Victor Owen","01/24/17 11:12AM","Telemed update some more descrption text would go here"],
            ["Bill Summers","01/25/17 10:52AM","Patient profile Screening update some more descrption text would go here"],
            ["Barrie Thomson","01/25/17 12:01PM","Referrals details update some more descrption text would go here"],
            ["Alice Njavro","01/26/17 07:02AM","patient profile update 2 some more descrption text would go here"],
            ["Elida Martinez","01/26/17 05:05PM","Patient medication some more descrption text would go here about medications and possible complications or interactions with dosage and medication type"],
            ["John Banks","01/26/17 07:25PM","patient Lunch Update some more descrption text would go here"],
            ["Patty Williams","01/26/17 09:43PM","DISPOSITION Patient profile IDT Update some more descrption text would go here"],
            ["Dian Simmons","01/27/17 12:32AM","musical IDT Update some more descrption text would go here"],
            ["Rrian Nird","01/27/17 01:56PM","Careflows update 1 some more descrption text would go here"],
            ["Josh Brown","01/27/17 03:22PM","DISPOSITION Patient profile IDT Update some more descrption text would go here"],
            ["Cindy Lopper","01/28/17 11:12AM","Patient profile Update some more descrption text would go here"],
            ["Dan Anderson","01/29/17 10:52AM","Telemed update some more descrption text would go here"],
            ["Paul Ryan","01/29/17 12:01PM","Patient profile Screening update some more descrption text would go here"],
            ["Ruth Quinones","01/30/17 07:02AM","Referrals details update some more descrption text would go here"],
            ["Betty Kim","01/30/17 05:05PM","patient profile update 2 some more descrption text would go here"],
            ["Sue Cohen","01/30/17 07:25PM","Patient medication some more descrption text would go here about medications and possible complications or interactions with dosage and medication type"],
            ["Jan Andrews","01/30/17 09:43PM","patient Lunch Update some more descrption text would go here"],
            ["Mike Devitt","01/31/17 10:23PM","DISPOSITION Patient profile IDT Update some more descrption text would go here"],
            ["Anita Cintash","02/01/17 09:11PM","musical IDT Update some more descrption text would go here"]
        ]*/

        var alertDataCount = 0
        if(alertData.isEmpty == false){
            alertDataCount = alertData.count
        }
        
        UserDefaults.standard.set(alertDataCount, forKey: "alertCount")
        UserDefaults.standard.set(alertData, forKey: "alertData")
        UserDefaults.standard.synchronize()
        
    }
    
    
}
