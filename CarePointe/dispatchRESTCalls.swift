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
        
//        let signin = DispatchGroup()
//        signin.enter()
//        
//        // 0 signin -----------
//        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
//        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
//        
//        POSTSignin().signInUser(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: signin)
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        // 1 token -----------
        //signin.notify(queue: DispatchQueue.main) {
            
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        //}// ------------------
        
        let downloadPatients = DispatchGroup()
            downloadPatients.enter()
        
        
        // 2 patients - notify closure called when (downloadToken) enter & leave counts balance
        downloadToken.notify(queue: DispatchQueue.main)  { //Signin token & user profile Downloaded now what?
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startActivityIndicator"), object: nil)
            
            let token = UserDefaults.standard.string(forKey: "token")
            
            GETPatients().getPatients(token: token!, dispachInstance: downloadPatients)
            
            //3 All Inbox Users -----------
            GETRecipients().getInboxUsers(token: token!)
        }
        
        let downloadAlerts = DispatchGroup()
        downloadAlerts.enter()
        
        let downloadReferrals = DispatchGroup()
        downloadReferrals.enter()
        
        downloadPatients.notify(queue:DispatchQueue.main){ //Patients Downloaded now do what?

            let token = UserDefaults.standard.string(forKey: "token")
            
            //4 Get All Global Alerts
            GETGlobalAlerts().getGlobalAlerts(token: token!, dispachInstance: downloadAlerts)
            
            //5 GET ALL Referrals
            //get local user profile
            let userProfile = UserDefaults.standard.object(forKey: "userProfile") as? Array<Dictionary<String,String>> ?? []
            if userProfile.isEmpty == false
            {
                let user = userProfile[0]
                
                //let token = user["Token"]!
                //let firstName = user["FirstName"]!
                //let lastName = user["LastName"]!
                //let title = user["Title"]!
                let uid = user["User_ID"]!
                //let email = user["EmailID1"]!
                //let phoneNo = user["PhoneNo"]!
                
                GETReferrals().getAllReferrals(token: token!, userID: uid, dispatchInstance: downloadReferrals)//"0")//122
            }
            
        }
        
        downloadAlerts.notify(queue:DispatchQueue.main) {//Alerts Downloaded now do what?
            
            //Stop Activity Indicator 2. Update Patient Profile 3. Update Alerts Count
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopActivityIndicator"), object: nil)
            
            //print #keys in user defaults
            print(UserDefaults.standard.dictionaryRepresentation().keys.count)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateProfile"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateAlerts"), object: nil)
            
        }
        
        downloadReferrals.notify(queue: DispatchQueue.main) {//got Referrals
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateReferrals"), object: nil)
            
        }

    }

}
