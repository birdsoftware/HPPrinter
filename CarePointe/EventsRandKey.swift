//
//  EventsRandKey.swift
//  CarePointe
//
//  Created by Brian Bird on 6/27/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//
// Tokbox Events by Random Key
//Request Payload:
//GET  http://carepointe.cloud:4300/api/eventtokbox/randomkey/HCNSb nHm9B
//Authorization:  Authorization Token

import Foundation

class GETEvents {
    
    func byRandKey(tokenSignIn: String, randomKey: String, dispachInstance: DispatchGroup){
        //print("got here")
        var events = Array<Dictionary<String,String>>()
        var event = Dictionary<String,String>()
        
        let nsurlAlerts = "http://carepointe.cloud:4300/api/eventtokbox/randomkey/" + randomKey
        
        let headers = [
            "authorization": tokenSignIn,
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
                    print("GET EventByRandKey Error:\n\(String(describing: error))")
                    dispachInstance.leave() // API Responded
                    return
                } else {
                    
                    do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                        if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let vJSON = json["data"] as? [[String: Any]] {
                            if(vJSON.isEmpty == false){
                                for dict in vJSON {
                                    
                                    let id = dict["id"] as? Int ?? 0
                                    let event_id = dict["event_id"] as? Int ?? 0
                                    let sessionid = dict["sessionid"] as? String ?? ""
                                    let token = dict["token"] as? String ?? ""
                                    let randomkey = dict["randomkey"] as? String ?? ""
                                    let archive = dict["archive"] as? String ?? ""
                                    let modtoken = dict["modtoken"] as? String ?? ""
                                    let owner_id = dict["owner_id"] as? Int ?? 0
                                    
                                    let ID = String(id)
                                    let eid = String(event_id)
                                    let oid = String(owner_id)
                                    
                                    events.append(["id":ID, "event_id":eid, "sessionid":sessionid, "token":token, "randomkey":randomkey, "archive":archive, "modtoken":modtoken,"owner_id":oid])
                                }
                                
                                event = events[0]
                                print("RESTEventByRandKey: \(event)")
                                UserDefaults.standard.set(event, forKey: "RESTEventByRandKey")
                                UserDefaults.standard.synchronize()
                                print("finished GET EventByRandKey")
                                dispachInstance.leave() // API Responded
                            }
                            //vitals came back empty?
                            //print("empty")
                        }
                    } catch {
                        print("Error deserializing EventByRandKey JSON: \(error)")
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
