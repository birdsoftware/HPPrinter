//
//  GETCase.swift
//  CarePointe
//
//  Created by Brian Bird on 7/25/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETCase {
    
    func getNTUCString(token: String, patientID: String, dispachInstance: DispatchGroup){

        var patientCase = Array<Dictionary<String,String>>()
        
        let nsurlAlerts = Constants.Case.patientCase + patientID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/case/patientId/"
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                    completionHandler: { (data, response, error) -> Void in
                        if (error != nil) {
                            print("GET RESTCase Error:\n\(String(describing: error))")
                            dispachInstance.leave() // API Responded
                            return
                        } else {
                            
                            do {
                                if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                    let vJSON = json["data"] as? [[String: Any]] {
                                    if(vJSON.isEmpty == false){
                                        for dict in vJSON {
                                            
                                            let Episode_ID = dict["Episode_ID"] as? Int ?? 0 //active episode, IsActive == Y
                                            let ntuc = dict["ntuc"] as? String ?? ""

                                            let eid = String(Episode_ID)
                                            
                                            patientCase.append(["Episode_ID":eid, "ntuc":ntuc])
                                        }
                                        
                                        UserDefaults.standard.set(patientCase, forKey: "RESTCase")
                                        UserDefaults.standard.synchronize()
                                        print("finished GET RESTCase")
                                        dispachInstance.leave() // API Responded
                                    }
                                    //vitals came back empty?
                                    print("empty")
                                }
                            } catch {
                                print("Error deserializing RESTCase JSON: \(error)")
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
