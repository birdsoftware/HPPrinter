//
//  RESTGETPatientRefer.swift
//  CarePointe
//
//  Created by Brian Bird on 5/5/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETPatientRefer {
    
    func getPatientReferral(token: String, patientID: String){//, dispachInstance: DispatchGroup){
        
        var patientReferral = Array<Dictionary<String,String>>()
        
        //varaibales to filter duplicate referrals
        var uniqueValues = Set<String>()
        
        let nsurlAlerts = Constants.Patient.patientReferral + patientID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/referrals/patientId/"
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
            completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("GET patient Referral Error:\n\(String(describing: error))")
                    //dispachInstance.leave() // API Responded
                    return
                } else {
                    
                    do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                        if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let vJSON = json["data"] as? [[String: Any]] {
                            if(vJSON.isEmpty == false){
                                for dict in vJSON {
                                    
                                    let ServiceCategory = dict["ServiceCategory"] as? String ?? ""
                                    let Status = dict["Status"] as? String ?? ""
                                    let StartDate = dict["StartDate"] as? String ?? ""
                                    
                                    let Care_Plan_ID = dict["Care_Plan_ID"] as? Int ?? 0
                                    let cpid = String(Care_Plan_ID)
                                    
                                    //Uncomment To make referrals unique - remove duplicates
                                    let beforeInsertCount = uniqueValues.count
                                    uniqueValues.insert(cpid) // will do nothing if Care_Plan_ID exists already
                                    let afterInsertCount = uniqueValues.count
                                     
                                       //define dictionary literals
                                    if beforeInsertCount != afterInsertCount {
                                    
                                        patientReferral.append(["ServiceCategory":ServiceCategory, "Status":Status, "StartDate":StartDate])
                                    }
                                }
                                
                                //careTeam = careTeams[0]
                                print("patientReferral: \(patientReferral)")
                                UserDefaults.standard.set(patientReferral, forKey: "RESTPatientReferral")
                                UserDefaults.standard.synchronize()
                                print("finished GET patient Referral")
                               // dispachInstance.leave() // API Responded
                            }
                            //patient referral came back empty?
                            print("patientReferral - empty")
                            UserDefaults.standard.set(patientReferral, forKey: "RESTPatientReferral")
                            UserDefaults.standard.synchronize()
                        }
                    } catch {
                        print("Error deserializing patientReferral JSON: \(error)")
                       // dispachInstance.leave() // API Responded
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
