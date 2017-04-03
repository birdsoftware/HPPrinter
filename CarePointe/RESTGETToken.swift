//
//  RESTSignIn.swift
//  CarePointe
//
//  Created by Brian Bird on 3/20/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
//import UIKit

class GETToken {

    func signInCarepoint(userEmail: String, userPassword: String, dispachInstance: DispatchGroup) {
        
        var token = String()
        
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "0e161852-1169-8f8e-335c-42a4d2389c25"
        ]
        let parameters = [
            "email": userEmail,
            "password": userPassword
            ] as [String : Any]

        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        //print(String(data: postData, encoding: .utf8)!) //{test@test.com, test123456}
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://carepointe.cloud:4300/api/authenticate")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("Error when Attempting to GET Token: \(error!)")
            } else {
                //let httpResponse = response as? HTTPURLResponse
                //print("\(httpResponse)")
                
                //let httpData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("Response String :\(httpData)")
             
                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let authData = json["data"] as? [[String: Any]] {
                        for aData in authData {
                            if let tokenBuff = aData["Token"] as? String {
                                
                                token = tokenBuff
                                //print("dataTask: \(token)")
                            }
                        }
                        //Update token
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.synchronize()
                        
                        print("finished GET Token")
                        dispachInstance.leave()
                        
                        
                        
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
                //DispatchQueue.main.async {
                    //Update your UI here
                    //activityIndicator.removeFromSuperview()
                    
//                    //Update token
//                    UserDefaults.standard.set(token, forKey: "token")
//                    UserDefaults.standard.synchronize()
//                    
//                    //GET Patients -> save in defaults:  all patients: forKey: "RESTPatients" & patientID column: forKey: "RESTPatientsPatientIDs"
//                    let getPatientsInstance = GETPatients()
//                    getPatientsInstance.getPatients(token: token)
//                    
//                    //GET Patient Alerts for each patientID-> defaults forKey: "RESTAlerts"
//                    let patientIDs = UserDefaults.standard.array(forKey: "RESTPatientsPatientIDs") as? [String] ?? [String]()
//                    
//                    print("\n patientID's: \(patientIDs)\n")
//                    
//                    let getAlertsInstance = GETAlerts()
//                    //let allAlerts = [[String]]()
//                    for patientID in patientIDs {
//                        getAlertsInstance.getAlerts(token: token, patientid: patientID)
//                    }
                    //let allAlerts = UserDefaults.standard.array(forKey: "RESTAlerts") as? [[String]] ?? [[String]]()
                    //print("\nall alerts: \(allAlerts)\n")
                    
                //}
                
            }//else
        })
        
        dataTask.resume()
        
        
    }
    
}
