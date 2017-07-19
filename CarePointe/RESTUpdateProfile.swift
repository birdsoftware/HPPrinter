//
//  RESTSignIn.swift
//  CarePointe
//
//  Created by Brian Bird on 3/20/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class PUTUpdateProfile {
    
    func updateProfile(token: String, userID: String, firstname: String, lastname: String, title:String, emailid:String, PhoneNo:String) {
        
        let headers = [
            "authorization":token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let parameters = [
            "firstname": firstname,
            "lastname": lastname,
            "title":title,
            "emailid":emailid,
            "PhoneNo":PhoneNo
            ] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        //print(String(data: postData, encoding: .utf8)!) //{test@test.com, test123456}
        
        let request = NSMutableURLRequest(url: NSURL(string: Constants.User.putProfile + userID)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/user/updateProfile/"
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                //let errorLocalDes = error?.localizedDescription
                
                print("Error when Attempting to PUT UpdateProfile: \(error!)") //The Internet connection appears to be offline. -1009
                
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signinAlert"), object: nil)
                UserDefaults.standard.set(false, forKey: "APIUpdateProfileSuccess")
                UserDefaults.standard.set("\(error!)", forKey: "APIUpdateProfileMessage")
                UserDefaults.standard.synchronize()
                
                
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
                            
                            UserDefaults.standard.set(true, forKey: "APIUpdateProfileSuccess")
                            UserDefaults.standard.synchronize()
                            
                            print("finished PUT UpdateProfile")
                        }
                    }
                } catch {
                    print("Error deserializing PUT UpdateProfile JSON: \(error)")
                    UserDefaults.standard.set(false, forKey: "APIUpdateProfileSuccess")
                    UserDefaults.standard.set("\(error)", forKey: "APIUpdateProfileMessage")
                    UserDefaults.standard.synchronize()
                }
                //DispatchQueue.main.async {
                //}
            }
        })
        dataTask.resume()
    }
}
