//
//  RESTGETPatientUpdates.swift
//  CarePointe
//
//  Created by Brian Bird on 5/19/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETPatientUpdates {
    
    func getPatientUpdates(token: String, patientID: String, dispachInstance: DispatchGroup){
        
        var patientUpdates = Array<Dictionary<String,String>>()
        
        //varaibales to filter duplicate referrals
        //var uniqueValues = Set<String>()
        
        let nsurlAlerts = "http://carepointe.cloud:4300/api/patientsupdates/patientId/" + patientID
        
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
                            print("GET patient Referral Error:\n\(String(describing: error))")
                            dispachInstance.leave() // API Responded
                            return
                    } else {
                        
                        do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                            if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let vJSON = json["data"] as? [[String: Any]] {
                                if(vJSON.isEmpty == false){
                                    for dict in vJSON {
                                        
                                        let PatientUpdateDate = dict["PatientUpdateDate"] as? String ?? ""
                                        let update_type = dict["update_type"] as? String ?? ""
                                        let updated_from = dict["updated_from"] as? String ?? ""
                                        let PatientUpdateText = dict["PatientUpdateText"] as? String ?? ""
                                        let CreatedByName = dict["CreatedByName"] as? String ?? ""
                                        
                                        let CreatedBy = dict["CreatedBy"] as? Int ?? 0
                                        let cb = String(CreatedBy)
                                        
                                        //Uncomment To make unique - remove duplicates
                                        //let beforeInsertCount = uniqueValues.count
                                        //uniqueValues.insert(cpid) // will do nothing if Care_Plan_ID exists already
                                        //let afterInsertCount = uniqueValues.count
                                        
                                        //if beforeInsertCount != afterInsertCount {
                                        
                                        //Reverse Order using .insert( ,at:0) instead of .append
                                        patientUpdates.insert(["PatientUpdateDate":PatientUpdateDate, "update_type":update_type, "updated_from":updated_from, "PatientUpdateText":PatientUpdateText, "CreatedBy":cb, "CreatedByName":CreatedByName], at:0)
                                       // }
                                    }
    
                                    //print("patientUpdates: \(patientUpdates)")
                                    UserDefaults.standard.set(patientUpdates, forKey: "RESTPatientUpdates")
                                    UserDefaults.standard.synchronize()
                                    print("finished GET patient Updates")
                                    dispachInstance.leave() // API Responded
                                }
                                //patient referral came back empty?
                                print("patient Updates - empty")
                                //UserDefaults.standard.set(patientReferral, forKey: "RESTPatientReferral")
                                //UserDefaults.standard.synchronize()
                            }
                        } catch {
                            print("Error deserializing patientReferral JSON: \(error)")
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
