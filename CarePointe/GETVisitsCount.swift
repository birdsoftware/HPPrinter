//
//  GETVisitsCount.swift
//  CarePointe
//
//  Created by Brian Bird on 7/26/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETEDCount {
    
    func getVisitsCount(token: String, patientID: String, dispachInstance: DispatchGroup){
        
        var visits = Array<Dictionary<String,String>>()
        
        let nsurlAlerts = Constants.ED.visitCount + patientID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/er/visits/patientId/"
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print("GET RESTEDVisitsCount Error:\n\(String(describing: error))")
                        dispachInstance.leave() // API Responded
                        return
                    } else {
                        
                        do {
                            if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let vJSON = json["data"] as? [[String: Any]] {
                                if(vJSON.isEmpty == false){
                                    for dict in vJSON {
                                        
                                        let VisitCount = dict["VisitCount"] as? String ?? "" //active episode, IsActive == Y
                                        let VisitedFrom = dict["VisitedFrom"] as? String ?? ""
                                        let VisitedTo = dict["VisitedTo"] as? String ?? ""
                                        
                                        //let shortDate = convertDateStringToDate(longDate: AdmittanceDate)
                                        
                                        visits.append(["VisitCount":VisitCount, "VisitedFrom":VisitedFrom, "VisitedTo":VisitedTo])
                                    }
                                    
                                    UserDefaults.standard.set(visits, forKey: "RESTEDVisitsCount")
                                    UserDefaults.standard.synchronize()
                                    print("finished GET RESTEDVisitsCount")
                                    dispachInstance.leave() // API Responded
                                }
                                //vitals came back empty?
                                print("empty")
                            }
                        } catch {
                            print("Error deserializing RESTEDVisits JSON: \(error)")
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
