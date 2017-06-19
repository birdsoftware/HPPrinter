//
//  GETCurMeds.swift
//  CarePointe
//
//  Created by Brian Bird on 6/16/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETMeds {
    
    func getCurMeds(token: String, patientID: String, dispachInstance: DispatchGroup){
        //print("got here")
        var meds = Array<Dictionary<String,String>>()
        
        let nsurlAlerts = "http://carepointe.cloud:4300/api/rx/curmeds/patientId/" + patientID
        
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
                                                print("GET Current Meds Error:\n\(String(describing: error))")
                                                dispachInstance.leave() // API Responded
                                                return
                                            } else {
                                                
                                                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                                                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                                        let vJSON = json["data"] as? [[String: Any]] {
                                                        if(vJSON.isEmpty == false){
                                                            for dict in vJSON {
                                                                
                                                                let medId = dict["id"] as? Int ?? 0
                                                                let med_id = dict["med_id"] as? String ?? ""
                                                                let medications = dict["medications"] as? String ?? "" //"Tylenol"
                                                                let dosage = dict["dosage"] as? String ?? ""
                                                                let frequency = dict["frequency"] as? String ?? ""
                                                                let route = dict["route"] as? String ?? ""
                                                                let UNITS = dict["UNITS"] as? String ?? ""
                                                                let REFILLCOUNT = dict["REFILLCOUNT"] as? String ?? ""
                                                                
                                                                let id = String(medId)
                                                                
                                                                meds.append(["id":id,"med_id":med_id, "medications":medications, "dosage":dosage, "frequency":frequency,"route":route,"UNITS":UNITS,"REFILLCOUNT":REFILLCOUNT])
                                                                
                                                            }
                                                            
                                                            print("Current Medications: \(meds)")
                                                            UserDefaults.standard.set(meds, forKey: "RESTCurrentMedications")
                                                            UserDefaults.standard.synchronize()
                                                            print("finished GET Current Meds")
                                                            dispachInstance.leave() // API Responded
                                                        }
                                                        //ct came back empty?
                                                        //print("empty")
                                                    }
                                                } catch {
                                                    print("Error deserializing Current Meds JSON: \(error)")
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
