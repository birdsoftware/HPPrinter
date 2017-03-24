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
    
    func beginRestCalls() {
        
        let downloadToken = DispatchGroup()
        
        downloadToken.enter()
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: "test@test.com", userPassword: "test123456", dispachInstance: downloadToken)
        
        
        let downloadPatients = DispatchGroup()
        downloadPatients.enter()
        
        // the notify closure is called when the (downloadToken-) groups enter and leave counts are balanced.
        downloadToken.notify(queue: DispatchQueue.main)  {
            //GET Patients -> save in defaults:  all patients: forKey: "RESTPatients" & patientID column: forKey: "RESTPatientsPatientIDs"
            let token = UserDefaults.standard.string(forKey: "token")
            let getPatientsInstance = GETPatients()
            getPatientsInstance.getPatients(token: token!, dispachInstance: downloadPatients)
        }
        
        //let downloadAlerts = DispatchGroup()
        //downloadAlerts.enter()
        
        downloadPatients.notify(queue:DispatchQueue.main){
            //GET Patient Alerts for each patientID-> defaults forKey: "RESTAlerts"
            let patientIDs = UserDefaults.standard.array(forKey: "RESTPatientsPatientIDs") as? [String] ?? [String]()
            let token = UserDefaults.standard.string(forKey: "token")
            print("\n patientID's: \(patientIDs)\n")
            
            let getAlertsInstance = GETAlerts()
            //let allAlerts = [[String]]()
            for patientID in patientIDs {
                getAlertsInstance.getAlerts(token: token!, patientid: patientID)
            }
        }
        

    }

}
