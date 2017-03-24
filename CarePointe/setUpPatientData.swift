//
//  setUpPatientData.swift
//  CarePointe
//
//  Created by Brian Bird on 2/17/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    
    func setUpPatientDataInDefaults() {
        
        
        //patientUniqid?
        let patientID = [["P00001","P00002","P00003","P00004","P00005","P00006","P00007","P00008","P00009"],
                         ["P00010","P00011","P00012","P00013"],
                         ["P00014","P00015","P00016","P00017","P00018","P00019","P00020","P00021","P00022","P00023","P00024"]]
        //?
        let appointmentIDs = [["90933","52718","12543","36221","160336","12718","68958","51500","27496"],
                              ["7498","47598","46233","78543"],
                              ["42321","36221","99699","25818","72021","372","86930","17498","23412","8975","76231"]]
        //firstName + lastName
        let patients = [["Ruth Quinones", "Barrie Thomson", "Victor Owen", "Bill Summers", "Alice Njavro", "Michael Levi", "Elida Martinez", "John Banks","Rrian Nird"],
                        [ "Cindy Lopper","Marx Ehrlich", "Alicia Watanabe", "Josh Brown"],
                        [ "Desire Aller", "Paulita Wix", "Jenny Binkley", "Lawanda Arno", "Jackqueline Naumann", "Regine Kohnke","Brad Birdsong", "Dallas Remy", "Noel Devitt","Mike Brown","Sev Donada"]]
        //?profileImage
        let patientImageNames = [["RuthQuinones.jpg","BarrieThomson.jpeg","VictorOwen.jpeg","BillSummers.jpeg","AliceNjavro.jpeg","","","",""],
                                 ["","","",""],
                                 ["","","","","","","","","","",""]]
        //createdDateTime
        let times = [["12:32 AM","01:56 PM","03:22 PM","11:12 AM","10:52 AM","12:01 PM","07:02 AM","05:05 PM","07:25 PM"],
                     ["12:32 AM","01:56 PM","03:22 PM","11:12 AM"],
                     ["12:32 AM","01:56 PM","03:22 PM","11:12 AM","10:52 AM","12:01 PM","07:02 AM","05:05 PM","07:25 PM","09:43 PM","10:52 AM"]]
        
        let dates = [["2/15/17","2/16/17","2/15/17","3/14/17","3/14/17","2/14/16","3/15/16","2/13/17","2/14/17"],
                     ["2/14/17","2/14/17","2/14/17","2/14/17"],
                     ["2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17"]]
        //?
        let appointmentMessage = [["Careflows update 1", "DISPOSITION Patient profile IDT Update",
                                   "order blood pressure plate", "Dr D. Webb Telemed update",
                                   "Patient profile Screening update", "Referrals details update",
                                   "syn patient card data", "Patient medication",
                                   "new nutrition levels"],
                                  ["new nutrition levels", "interface IDT Update",
                                   "Monitor infusion plasma", "DISPOSITION Patient profile IDT Update"],
                                  ["Patient profile Update", "Telemed update",
                                   "Patient profile Screening update", "Referrals details update",
                                   "monitor profile update 2", "Patient medication calculation",
                                   "patient Lunch Update", "hearing aid configuration","Dr D. Webb Telemed update",
                                   "Patient profile Screening update", "Referrals details update"]]
        
        self.setUpAlertDataInDefaults()
        self.setUpFeedDataInDefaults()
        self.setUpInBoxDataInDefaults()
        self.setUpSentBoxDataInDefaults()
        self.setUpUserDataInDefaults()
        
        UserDefaults.standard.set(appointmentIDs, forKey: "appID")
        UserDefaults.standard.set(patients, forKey: "appPat")
        UserDefaults.standard.set(patientImageNames, forKey: "appPatImage")
        UserDefaults.standard.set(times, forKey: "appTime")
        UserDefaults.standard.set(dates, forKey: "appDate")
        UserDefaults.standard.set(appointmentMessage, forKey: "appMessage")
        UserDefaults.standard.set(patientID, forKey: "patientID")
        UserDefaults.standard.synchronize()
        
    }
    
    
}
