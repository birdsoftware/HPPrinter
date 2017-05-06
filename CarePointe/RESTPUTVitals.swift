//
//  RESTPUTVitals.swift
//  CarePointe
//
//  Created by Brian Bird on 5/3/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class PUTVitals {
    
    func updateVitals(token: String, patientID: String, height:String, weight:String, bmi:String, bmiStatus:String,
                      bodyTemp:String, bpLocation:String, respRate: String, dispachInstance: DispatchGroup) {
        
        let headers = [
            "authorization":token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let parameters = [
            "height": height,
            "weight": weight,
            "bmi":bmi,
            "bmi_status":bmiStatus,
            "body_temp":bodyTemp,
            "bp_sitting_sys_dia":bpLocation,
            "respiratory_rate":respRate
            ] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        //print(String(data: postData, encoding: .utf8)!) //{test@test.com, test123456}
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://carepointe.cloud:4300/api/patientvitals/patientId/"+patientID)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                //let errorLocalDes = error?.localizedDescription
                
                print("Error when Attempting to PUT Vitals: \(error!)") //The Internet connection appears to be offline. -1009
                
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signinAlert"), object: nil)
                //UserDefaults.standard.set(false, forKey: "APIUpdateProfileSuccess")
                //UserDefaults.standard.set("\(error!)", forKey: "APIUpdateProfileMessage")
                //UserDefaults.standard.synchronize()
                dispachInstance.leave() // API Responded
                
            } else {
                
                //let httpResponse = response as? HTTPURLResponse
                //print("\(httpResponse)")
                //print("Status Code : \(httpResponse!.statusCode)")
                
                //let httpData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("Response String :\(httpData)")
                
                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let type = json["type"] as? Bool{
                        if(type == true){
                            
                            //UserDefaults.standard.set(true, forKey: "APIUpdateProfileSuccess")
                            //UserDefaults.standard.synchronize()
                            
                            print("finished PUT UpdateProfile")
                        }
                        dispachInstance.leave() // API Responded
                    }
                } catch {
                    print("Error deserializing PUT Vitals JSON: \(error)")
                    //UserDefaults.standard.set(false, forKey: "APIUpdateProfileSuccess")
                    //UserDefaults.standard.set("\(error)", forKey: "APIUpdateProfileMessage")
                    //UserDefaults.standard.synchronize()
                    dispachInstance.leave() // API Responded
                }
                //DispatchQueue.main.async {
                //}
            }
        })
        dataTask.resume()
    }
}
