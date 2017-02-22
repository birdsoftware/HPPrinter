//
//  moveAppointmentFromAcceptedToCompleted.swift
//  CarePointe
//
//  Created by Brian Bird on 2/21/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

//search for  "filterAppointmentID" from user defaults in appID[1] and move to appID[2]
// moveFromAcceptedToCompletedFor(AppointmentID: filterAppointmentID)

extension UIViewController {

    func moveFromAcceptedToCompletedFor(AppointmentID: String){
        print(AppointmentID)
        
        var appID = [[String]]() //empty array of arrays of type string
        var appPat = [[String]]()
        var appTime = [[String]]()
        var appDate = [[String]]()
        var appMessage = [[String]]()
        
        //Get up to date arrays for appID, appPat
        //------------------
        let appIDT = UserDefaults.standard.object(forKey: "appID")
        let appPatT = UserDefaults.standard.object(forKey: "appPat")
        let appTimeT = UserDefaults.standard.object(forKey: "appTime")
        let appDateT = UserDefaults.standard.object(forKey: "appDate")
        let appMessageT = UserDefaults.standard.object(forKey: "appMessage")
        if let appIDT = appIDT {
            appID = appIDT as! [[String]]
        }
        
        if let appPatT = appPatT {
            appPat = appPatT as! [[String]]
        }
        if let appTimeT = appTimeT {
            appTime = appTimeT as! [[String]]
        }
        
        if let appDateT = appDateT {
            appDate = appDateT as! [[String]]
        }
        if let appMessageT = appMessageT {
            appMessage = appMessageT as! [[String]]
        }
        
        //IF FOUND IT
        if let i = appID[1].index(of: AppointmentID){
            
            let appointmentID = appID[1][i]
            let patientName = appPat[1][i]
            let associatedTime = appTime[1][i]
            let associatedDay = appDate[1][i]
            let associatedMessage = appMessage[1][i]
            
            //remove FROM accepted appointment[1] TO completed appointment[2]
            appID[1].remove(at: i)
            appPat[1].remove(at: i)
            appTime[1].remove(at: i)
            appDate[1].remove(at: i)
            appMessage[1].remove(at: i)
            
            appID[2].append(appointmentID)
            appPat[2].append(patientName)
            appTime[2].append(associatedTime)
            appDate[2].append(associatedDay)
            appMessage[2].append(associatedMessage)
            
            //save to disk
            UserDefaults.standard.set(appID, forKey: "appID")
            UserDefaults.standard.set(appPat, forKey: "appPat")
            UserDefaults.standard.set(appTime, forKey: "appTime")
            UserDefaults.standard.set(appDate, forKey: "appDate")
            UserDefaults.standard.set(appMessage, forKey: "appMessage")
            UserDefaults.standard.synchronize()
            
        }
        
        
    }
    
}

