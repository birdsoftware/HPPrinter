//
//  DELETECurMed.swift
//  CarePointe
//
//  Created by Brian Bird on 7/13/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class DeleteMed {
    
    func aCurrentMed(token: String, medId: String, dispachInstance: DispatchGroup) {
        
        let headers = [
            "authorization":token,
            "content-type": "application/json",
            //"cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: Constants.Patient.deleteMedication+medId)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/rx/curmeds/medId/"
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                print("Error when Attempting to DELETE current medication: \(error!)") //The Internet connection appears to be offline. -1009
                UserDefaults.standard.set(false, forKey: "APIdeleteCurMedSuccess")
                UserDefaults.standard.synchronize()
                
                dispachInstance.leave() // API Responded
                
            } else {
                
                //let httpResponse = response as? HTTPURLResponse
                //print("\(httpResponse)")
                //print("Status Code : \(httpResponse!.statusCode)") //TODO check if 200 display message sent o.w. message not sent try later?
                
                //let httpData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("Response String :\(httpData)")
                
                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let type = json["type"] as? Bool{
                        if(type == true){
                            
                            UserDefaults.standard.set(true, forKey: "APIdeleteCurMedSuccess")
                            UserDefaults.standard.synchronize()
                            
                            print("finished DELETE current medication")
                        }
                        dispachInstance.leave() // API Responded
                    }
                } catch {
                    print("Error deserializing DELETE current medication: \(error)")
                    UserDefaults.standard.set(false, forKey: "APIdeleteCurMedSuccess")
                    UserDefaults.standard.synchronize()
                    
                    dispachInstance.leave() // API Responded
                }
                //DispatchQueue.main.async {
                //}
            }
        })
        dataTask.resume()
    }
}

