//
//  RESTGETPatients.swift
//  CarePointe
//
//  Created by Brian Bird on 3/23/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

//
//  RESTPatients.swift
//  testRestAPI
//
//  Created by Brian Bird on 3/21/17.
//  Copyright © 2017 Brian Bird. All rights reserved.
//

import Foundation
//import UIKit

class GETAlerts {
    
    func getAlerts(token: String, patientid: String) {
        
        var alerts = [[String]]()
        let nsurlAlerts = "http://carepointe.cloud:4300/api/alerts/patientId/" + patientid
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache",
            "postman-token": "5b46169a-a62b-bd4a-e93f-5056ff0b508a"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                                        completionHandler: { (data, response, error) -> Void in
                                            if (error != nil) {
                                                print("Error:\n\(error)")
                                                return
                                            } else {
                                                
                                                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                                                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                                        let alertsJSON = json["data"] as? [[String: Any]] {
                                                        for alert in alertsJSON {
                                                            let tableID = alert["tblid"] as? Int ?? -1 //------
                                                            let userID = alert["userid"] as? Int ?? -1 //------
                                                            let patientID = alert["patientid"] as? Int ?? -1 //------
                                                            let manageAlertID = alert["manage_alert_id"] as? Int ?? -1 //------
                                                            let createdDateTime = alert["createdDate"] as? String ?? ""
                                                            let isViewed = alert["isViewed"] as? Int ?? -1 //------
                                                            let status = alert["status"] as? String ?? "" //can be null ""
                                                            let note = alert["note"] as? String ?? ""
                                                            
                                                            //conver Ints to strings for uniform String Array bellow
                                                            let tid = String(tableID)
                                                            let uid = String(userID)
                                                            let pid = String(patientID)
                                                            let maid = String(manageAlertID)
                                                            let isView = String(isViewed)
                                                            
                                                            alerts.append([tid, uid, pid, maid, createdDateTime, isView, status, note])
                                                        }
                                                    }
                                                } catch {
                                                    print("Error deserializing Patients JSON: \(error)")
                                                }
                                                
                                                //                let httpResponse = response as? HTTPURLResponse
                                                //
                                                //
                                                //                print("Status Code : \(httpResponse!.statusCode)")
                                                //
                                                //let httpData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                //                print("Response String :\(httpData)")
                                                if(alerts.isEmpty == false){
                                                    print("\n")
                                                    print(alerts)
                                                    print("\n")
                                                
                                                    DispatchQueue.main.async {
                                                        
                                                        UserDefaults.standard.set(alerts, forKey: "RESTAlerts")
                                                        UserDefaults.standard.synchronize()
                                                        
                                                        
                                                    }
                                                }
                                                
                                            }
        })
        
        dataTask.resume()
        
    }
    
}


