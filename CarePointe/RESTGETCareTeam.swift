//
//  RESTGETCareTeam.swift
//  CarePointe
//
//  Created by Brian Bird on 5/4/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETCareTeam {
    
    func getCT(token: String, patientID: String, dispachInstance: DispatchGroup){
        //print("got here")
        var careTeams = Array<Dictionary<String,String>>()

        
        let nsurlAlerts = "http://carepointe.cloud:4300/api/caseteam/patientId/" + patientID
        
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
                        print("GET Care Team Error:\n\(String(describing: error))")
                        dispachInstance.leave() // API Responded
                        return
                    } else {
                        
                        do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                            if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let vJSON = json["data"] as? [[String: Any]] {
                                if(vJSON.isEmpty == false){
                                    for dict in vJSON {
                                        
                                        let title = dict["title"] as? String ?? ""
                                        let caseteam_name = dict["caseteam_name"] as? String ?? ""
                                        let phone_number = dict["phone_number"] as? String ?? ""
                                        let emailID = dict["emailID"] as? String ?? ""
                                        //let patient_id = dict["patient_id"] as? Int ?? 0
                                        let userID = dict["User_ID"] as? Int ?? 0
                                        let RoleType = dict["RoleType"] as? String ?? ""
                                        
                                        let uid = String(userID)
                                        
                                        careTeams.append(["title":title, "caseteam_name":caseteam_name, "phone_number":phone_number, "emailID":emailID,"RoleType":RoleType,"User_ID":uid])
               
                                    }
          
                                    print("v: \(careTeams)")
                                    UserDefaults.standard.set(careTeams, forKey: "RESTCareTeam")
                                    UserDefaults.standard.synchronize()
                                    print("finished GET Care Team")
                                    dispachInstance.leave() // API Responded
                                }
                                //ct came back empty?
                                print("empty")
                            }
                        } catch {
                            print("Error deserializing Care Team JSON: \(error)")
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
