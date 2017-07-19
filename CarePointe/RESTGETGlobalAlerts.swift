//
//  RESTGETUsers.swift
//  CarePointe
//
//  Created by Brian Bird on 3/28/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETGlobalAlerts {
    
    func getGlobalAlerts(token: String, dispachInstance: DispatchGroup) {
        
        var alerts = Array<Dictionary<String,String>>()
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: Constants.User.globalAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/alerts"
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                                        completionHandler: { (data, response, error) -> Void in
                                            if (error != nil) {
                                                print("Error when Attempting to GET Global Alerts:\(error!)")
                                                dispachInstance.leave() // API Responded
                                                return
                                            } else {
                                                
                                                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                                                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                                        let JSON = json["data"] as? [[String: Any]] {
                                                        if(JSON.isEmpty == false){
                                                            
                                                            for dict in JSON {
                                                                
                                                                let alertID = dict["alertid"] as? Int ?? -1
                                                                let alertName = dict["alert_name"] as? String ?? ""
                                                                let alertCategory = dict["alert_category"] as? String ?? ""
                                                                let alertPosition = dict["alert_position"] as? String ?? ""    //Combine with firstName
                                                                let alertAccess = dict["alert_access"] as? String ?? ""
                                                                let alertMessage = dict["alert_message"] as? String ?? ""
                                                                let createdDate = dict["created_date"] as? String ?? ""
                                                                let alertAccessRoles = dict["alert_access_roles"] as? String ?? ""
                                                                //"left_field": "ComplexityLevel",
                                                                //"system_condition": "Equals",
                                                                //"right_field": "High",
                                                                //"device_id": 0,
                                                                //"device_high": "",
                                                                //"device_low": "",
                                                                
                                                                let aid = String(alertID)
                                                                
                                                                //define dictionary literals
                                                                //http://stackoverflow.com/questions/30418101/find-key-value-pair-in-an-array-of-dictionaries
                                                                alerts.append(["alertid":aid, "alert_name":alertName, "alert_category":alertCategory, "alert_position":alertPosition,
                                                                               "alert_access":alertAccess, "alert_message":alertMessage, "created_date":createdDate, "alert_access_roles":alertAccessRoles])
                                                            }
                                                            
                                                            dispachInstance.leave() // API Responded
                                                            
                                                            UserDefaults.standard.set(alerts, forKey: "RESTGlobalAlerts")
                                                            UserDefaults.standard.synchronize()
                                                            
                                                            print("finished GET Global Alerts")
                                                            
                                                        }
                                                    }
                                                } catch {
                                                    print("Error deserializing Inbox Users JSON: \(error)")
                                                    dispachInstance.leave() // API Responded
                                                }
                                                
                                                /* //~~~~~~~~uncomment to run code now before this task completes
                                                 DispatchQueue.main.async {
                                                 //code to run right now before this dataTask completes wait
                                                 }
                                                 */ //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                            }
        })
        
        dataTask.resume()
        
    }
    
}


