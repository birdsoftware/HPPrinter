//
//  dispatchRESTCalls.swift
//  CarePointe
//
//  Created by Brian Bird on 3/24/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class DispatchREST {//http://stackoverflow.com/questions/42146274/syncronize-async-functions
    //https://www.raywenderlich.com/148515/grand-central-dispatch-tutorial-swift-3-part-2
    //http://stackoverflow.com/questions/30418101/find-key-value-pair-in-an-array-of-dictionaries
    
    func beginRestCalls() {
        
        let signin = DispatchGroup()
        signin.enter()
        
        // 0 signin -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let postSignIN = POSTSignin()
            postSignIN.signInUser(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: signin)
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        // 1 token -----------
        signin.notify(queue: DispatchQueue.main) {
            
        let getToken = GETToken()
            getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadToken) //  "admin@carepointe.com" "Phoenix2016"
        
        }// ------------------
        
        let downloadPatients = DispatchGroup()
            downloadPatients.enter()
        
        // 2 patients  -----------
        //notify closure called when (downloadToken-) enter and leave counts are balanced
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            //GET Patients -> save in defaults:  all patients: forKey: "RESTPatients" & patientID column: forKey: "RESTPatientsPatientIDs"
            let token = UserDefaults.standard.string(forKey: "token")
            let callGetPatients = GETPatients()
                callGetPatients.getPatients(token: token!, dispachInstance: downloadPatients)
            
            //3 users
            let callGetUsers = GETRecipients()
                callGetUsers.getInboxUsers(token: token!)
        }// -----------------------
        
        //let downloadAlerts = DispatchGroup()
        //downloadAlerts.enter()
        
        downloadPatients.notify(queue:DispatchQueue.main){
            UserDefaults.standard.set(nil, forKey: "RESTAlerts")//clear old
            UserDefaults.standard.synchronize()
            
            //
            // GET Patient Alerts for each patientID -> defaults forKey: "RESTAlerts"
            //
            let patientIDs = UserDefaults.standard.array(forKey: "RESTPatientsPatientIDs") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()//as? [String] ?? [String]()
            //let token = UserDefaults.standard.string(forKey: "token")
            print("\n patientID's: \(patientIDs)\n")
            
            //let getAlertsInstance = GETAlerts()
            
            //for dict in patientIDs {
            //     getAlertsInstance.getAlerts(token: token!, patientDict: dict)//TODO: convert [[String]] to Array<Dictionary<String,String>>
            //}

            
            
            //print #keys in user defaults
            print(UserDefaults.standard.dictionaryRepresentation().keys.count)
        }

    }

}
