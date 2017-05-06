//
//  RESTGETVitals.swift
//  CarePointe
//
//  Created by Brian Bird on 5/3/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETVitals {
    
    func getVitals(token: String, patientID: String, dispachInstance: DispatchGroup){
        //print("got here")
        var vitals = [[String]]()//Array<Dictionary<String,String>>()
        var vital = [String]()//Dictionary<String,String>()
        
        let nsurlAlerts = "http://carepointe.cloud:4300/api/patientvitals/patientId/" + patientID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
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
                    print("GET Vitals Error:\n\(String(describing: error))")
                    dispachInstance.leave() // API Responded
                    return
                } else {
                    
                    do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                        if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let vJSON = json["data"] as? [[String: Any]] {
                            if(vJSON.isEmpty == false){
                                for dict in vJSON {
                                    
                                    let height = dict["height"] as? String ?? ""
                                    let weight = dict["weight"] as? String ?? ""
                                    let bmi = dict["bmi"] as? String ?? ""
                                    let bmi_status = dict["bmi_status"] as? String ?? ""
                                    let body_temp = dict["body_temp"] as? String ?? ""
                                    let bp_sitting_sys_dia = dict["bp_sitting_sys_dia"] as? String ?? ""
                                    let respiratory_rate = dict["respiratory_rate"] as? String ?? ""
                                    let update_date_time = dict["update_date_time"] as? String ?? ""
                                    
                                    vitals.append([height, weight, bmi,bmi_status,body_temp, bp_sitting_sys_dia,respiratory_rate, update_date_time])
                                    //(["height":height, "weight":weight, "bmi":bmi,"bmi_status":bmi_status,"body_temp":body_temp,
                                    //"bp_sitting_sys_dia":bp_sitting_sys_dia,"respiratory_rate":respiratory_rate,
                                    //"update_date_time":update_date_time])
                                }
                                
                                vital = vitals[0]
                                print("v: \(vital)")
                                UserDefaults.standard.set(vital, forKey: "RESTVitals")
                                UserDefaults.standard.synchronize()
                                print("finished GET Vitals")
                                dispachInstance.leave() // API Responded
                            }
                            //vitals came back empty?
                            print("empty")
                        }
                    } catch {
                        print("Error deserializing Vitals JSON: \(error)")
                        dispachInstance.leave() // API Responded
                    }
                    /* uncomment to run code now before this task completes
                     DispatchQueue.main.async {
                     //code to run right now before this dataTask completes wait
                     }
                     */
                }
        })
        dataTask.resume()
    }
}
