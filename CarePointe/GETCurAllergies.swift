//
//  GETCurAllergies.swift
//  CarePointe
//
//  Created by Brian Bird on 6/24/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETAllergies {
    
    func getCurAllergies(token: String, patientID: String, dispachInstance: DispatchGroup){
        //print("got here")
        var Allallergies = Array<Dictionary<String,String>>()
        
        let nsurlAlerts = Constants.Patient.patientAllergies + patientID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//http://carepointe.cloud:4300/api/rx/allergy/patientId/
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
            completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("GET Current Allergies Error:\n\(String(describing: error))")
                    dispachInstance.leave() // API Responded
                    return
                } else {
                    
                    do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                        if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let vJSON = json["data"] as? [[String: Any]] {
                            if(vJSON.isEmpty == false){
                                for dict in vJSON {
                                    
                                    let alId = dict["id"] as? Int ?? 0
                                    let allergy_id = dict["allergy_id"] as? Int ?? 0
                                    let allergies = dict["allergies"] as? String ?? ""//"9993-Peanut Oil"
                                    let reaction = dict["reaction"] as? String ?? ""
                                    let serverity = dict["serverity"] as? String ?? ""
                                    let date_recognized = dict["date_recognized"] as? String ?? ""//"05/01/2017"
                                    
                                    let id = String(alId)
                                    let aid = String(allergy_id)
                                    
                                    Allallergies.append(["id":id,"allergy_id":aid, "allergies":allergies, "reaction":reaction, "serverity":serverity,"date_recognized":date_recognized])
                                    
                                }
                                
                                print("Current Allergies: \(Allallergies)")
                                UserDefaults.standard.set(Allallergies, forKey: "RESTCurrentAllergies")
                                UserDefaults.standard.synchronize()
                                print("finished GET Current Allergies")
                                dispachInstance.leave() // API Responded
                            }
                            //ct came back empty?
                            //print("empty")
                        }
                    } catch {
                        print("Error deserializing Current Allergies JSON: \(error)")
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
