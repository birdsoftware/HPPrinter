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
    
    func getAlerts(token: String, patientDict: Dictionary<String,String>){
        
        //var alerts = [[String]]()
        let patientid = patientDict["Patient_ID"]
        let patientName = patientDict["patientName"]

        let nsurlAlerts = "http://carepointe.cloud:4300/api/alerts/patientId/" + patientid!
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
            //"postman-token": "5b46169a-a62b-bd4a-e93f-5056ff0b508a"
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
                                                print("GET Alerts Error:\n\(String(describing: error))")
                                                return
                                            } else {
                                                
                                                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                                                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                                        let alertsJSON = json["data"] as? [[String: Any]] {
                                                        if(alertsJSON.isEmpty == false){
                                                            var allAlerts = UserDefaults.standard.array(forKey: "RESTAlerts") as? [[String]] ?? [[String]]()
                                                            
                                                            for alert in alertsJSON {
                                                                //let tableID = alert["tblid"] as? Int ?? -1 //------
                                                                //let userID = alert["userid"] as? Int ?? -1 //------
                                                                //let patientID = alert["patientid"] as? Int ?? -1 //------
                                                                let manageAlertID = alert["manage_alert_id"] as? Int ?? -1 //------
                                                                let createdDateTime = alert["createdDate"] as? String ?? ""
                                                                let isViewed = alert["isViewed"] as? Int ?? -1 //------
                                                                let status = alert["status"] as? String ?? "" //can be null ""
                                                                let note = alert["note"] as? String ?? ""
                                                                
                                                                //conver Ints to strings for uniform String Array bellow
                                                                //let tid = String(tableID)
                                                                //let uid = String(userID)
                                                                //let pid = String(patientID)
                                                                let alertTitle = self.manageAlert(code: manageAlertID)//String(manageAlertID) //1=Complexity High, 2=Sugar Level, 3=Sugar Levels test, 5=Urgent Status
                                                                let isView = String(isViewed)
                                                                
                                                                //alerts.append([tid, uid, pid, maid, createdDateTime, isView, status, note])
                                                                allAlerts.append([patientName!, alertTitle, createdDateTime, isView, status, note])
                                                                
                                                            }
                                                            
                                                            
                                                            print("\n")
                                                            print(allAlerts)
                                                            print("\n")

                                                           UserDefaults.standard.set(allAlerts, forKey: "RESTAlerts")
                                                           UserDefaults.standard.synchronize()
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
//                                               if(alertsJSON.isEmpty == false){
//                                                
//                                                    print("\n")
//                                                    print(alerts)
//                                                    print("\n")
//                                                UserDefaults.standard.set(alerts, forKey: "RESTAlerts")
//                                                UserDefaults.standard.synchronize()
//                                                
//                                                
//                                                    DispatchQueue.main.async { //happens now before dataTask finishes
//                                                        //UserDefaults.standard.set(alerts, forKey: "RESTAlerts")
//                                                        //UserDefaults.standard.synchronize()
//                                                        
//                                                        
//                                                    }
//                                                }
                                                
                                            }
        })
        
        dataTask.resume()


    }
    
    func manageAlert(code: Int) -> String {
        
        //1=Complexity High, 2=Sugar Level, 3=Sugar Levels test, 5=Urgent Status
        var codeString:String
        
        switch code{
            case 1: codeString = "Complexity High"
            case 2: codeString = "Sugar Level"
            case 3: codeString = "Sugar Levels test"
            case 5: codeString = "Urgent Status"
            default: codeString = ""
        }
        
        return codeString
    }
}


