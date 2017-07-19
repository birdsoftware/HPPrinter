//
//  RESTSignIn.swift
//  CarePointe
//
//  Created by Brian Bird on 3/20/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
//import UIKit

class POSTSignin {
    
    func signInUser(userEmail: String, userPassword: String, dispachInstance: DispatchGroup) {

        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache"
            //"postman-token": "0e161852-1169-8f8e-335c-42a4d2389c25"
        ]
        let parameters = [
            "email": userEmail,
            "password": userPassword
            ] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        //print(String(data: postData, encoding: .utf8)!) //{test@test.com, test123456}
        
        let request = NSMutableURLRequest(url: NSURL(string: Constants.Authentication.signinURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/signin"
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                //let errorLocalDes = error?.localizedDescription
                
                print("Error when Attempting to POST Signin: \(error!)") //The Internet connection appears to be offline. -1009
                
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signinAlert"), object: nil)
                UserDefaults.standard.set(false, forKey: "APISignedInSuccess")
                UserDefaults.standard.set("\(error!)", forKey: "APISignedInErrorMessage")
                UserDefaults.standard.synchronize()
                dispachInstance.leave() // API Responded
                
            } else {
                
//                let httpResponse = response as? HTTPURLResponse
//                print("\(httpResponse!)")
//                print("Status Code : \(httpResponse!.statusCode)")
//                
//                let httpData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print("Response String :\(httpData!)")
                
                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let type = json["type"] as? Bool{
                            if(type == true){

                                UserDefaults.standard.set(true, forKey: "APISignedInSuccess")
                                UserDefaults.standard.set("none", forKey: "APISignedInErrorMessage")
                                UserDefaults.standard.synchronize()
                                
                                print("finished POST Signin")
                                
                                
                            } else {
                                let errorMessage = json["data"] as? String //API will return {"type":"false","data":"User password does not match" or "User with this Username does not exist"
                                
                                print("could not POST Signin: \(errorMessage!)")
                                
                                UserDefaults.standard.set(false, forKey: "APISignedInSuccess")
                                UserDefaults.standard.set(errorMessage, forKey: "APISignedInErrorMessage")
                                UserDefaults.standard.synchronize()
                            }
                        dispachInstance.leave() // API Responded
                    }
                } catch {
                    print("Error deserializing signin JSON: \(error)")
                    UserDefaults.standard.set(false, forKey: "APISignedInSuccess")
                    UserDefaults.standard.set("\(error)", forKey: "APISignedInErrorMessage")
                    UserDefaults.standard.synchronize()
                    dispachInstance.leave() // API Responded
                }
                
                //DispatchQueue.main.async {
                //}
                
            }//else
        })
        
        dataTask.resume()
        
        
    }
    
}
