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
        
        
        // 2 patients - notify closure called when (downloadToken) enter & leave counts balance
        downloadToken.notify(queue: DispatchQueue.main)  { //Signin token & user profile Downloaded now what?
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startActivityIndicator"), object: nil)
            
            let token = UserDefaults.standard.string(forKey: "token")
            
            let startGetPatients = GETPatients()
                startGetPatients.getPatients(token: token!, dispachInstance: downloadPatients)
            
            //3 All Inbox Users -----------
            let startGetUsers = GETRecipients()
                startGetUsers.getInboxUsers(token: token!)
        }
        
        let downloadAlerts = DispatchGroup()
        downloadAlerts.enter()
        
        downloadPatients.notify(queue:DispatchQueue.main){ //Patients Downloaded now do what?

            let token = UserDefaults.standard.string(forKey: "token")
            
            //4 Get All Global Alerts
            let startGlobalAlerts = GETGlobalAlerts()
            startGlobalAlerts.getGlobalAlerts(token: token!, dispachInstance: downloadAlerts)
            
            //5 GET ALL Referrals
            let referrals = GETReferrals()
            referrals.getAllReferrals(token: token!, userID: "122")
            
        }
        
        downloadAlerts.notify(queue:DispatchQueue.main) {//Alerts Downloaded now do what?
            
            //Stop Activity Indicator 2. Update Patient Profile 3. Update Alerts Count
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopActivityIndicator"), object: nil)
            
            //print #keys in user defaults
            print(UserDefaults.standard.dictionaryRepresentation().keys.count)
            
        }

    }

}
