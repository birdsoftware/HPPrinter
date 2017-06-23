//
//  RESTSignIn.swift
//  CarePointe
//
//  Created by Brian Bird on 3/20/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
//import UIKit

class GETToken {

    func signInCarepoint(/*userEmail: String, userPassword: String, */dispachInstance: DispatchGroup) {
        
        let userEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let userPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        var userProfile:Array<Dictionary<String,String>> = []
        
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
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://carepointe.cloud:4300/api/authenticate")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("Error when Attempting to GET Token: \(error!)")
                UserDefaults.standard.set(false, forKey: "APIGETTokenSuccess")
                UserDefaults.standard.synchronize()
                dispachInstance.leave()
            } else {
                //let httpResponse = response as? HTTPURLResponse
                //print("\(httpResponse)")
                
                //let httpData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print("Response String :\(httpData)")
             
                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let authData = json["data"] as? [[String: Any]] {
                        for aData in authData {
                            let token = aData["Token"] as? String ?? ""
                            let User_ID = aData["User_ID"] as? Int ?? 0 //356
                            let RoleType = aData["RoleType"] as? String ?? "" //"Physician"
                            let RoleID = aData["Role_ID"] as? String ?? "" //"6"
                            let Title = aData["Title"] as? String ?? ""
                           // let UserName = aData["UserName"] as? String ?? "" //"test@test.com"
                           // let Password = aData["Password"] as? String ?? "" //"47ec2dd791e31e2ef2076caf64ed9b3d"
                            let FirstName = aData["FirstName"] as? String ?? ""
                            let LastName = aData["LastName"] as? String ?? ""
                            //let profile_image = aData["profile_image"] as? String ?? ""
                            let EmailID1 = aData["EmailID1"] as? String ?? ""
                            let phoneNo = aData["PhoneNo"] as? String ?? ""
                            
                            let uid = String(User_ID)
                            let profileName = FirstName
                            let profileLastName = LastName
                            let firstLastName = FirstName + " " + LastName
                            
                            userProfile.append(["FirstName":FirstName, "LastName":LastName, "Token":token,"userName":firstLastName,"RoleType":RoleType, "Role_ID":RoleID, "Title":Title, "EmailID1":EmailID1, "User_ID":uid, "PhoneNo":phoneNo])
                            
                            UserDefaults.standard.set(token, forKey: "token")
                            UserDefaults.standard.set(profileName, forKey: "profileName")
                            UserDefaults.standard.set(profileLastName, forKey: "profileLastName")
                            UserDefaults.standard.set(Title, forKey: "title")
                            UserDefaults.standard.set(EmailID1, forKey: "EmailID1")
                            
                            UserDefaults.standard.set(userProfile, forKey: "userProfile")
                            UserDefaults.standard.synchronize()
                            
                        }
                        UserDefaults.standard.set(true, forKey: "APIGETTokenSuccess")
                        UserDefaults.standard.synchronize()
                        
                        print("finished GET Token")
                        dispachInstance.leave()
                        
                        
                        
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                    UserDefaults.standard.set(false, forKey: "APIGETTokenSuccess")
                    UserDefaults.standard.synchronize()
                    dispachInstance.leave()
                }
                
                //DispatchQueue.main.async {
                                        
                //}
                
            }//else
        })
        
        dataTask.resume()
        
        
    }
    
    
//    func manageRoleID(code: String) -> String {
//        //1=Complexity High, 2=Sugar Level, 3=Sugar Levels test, 5=Urgent Status
//        var codeString:String
//        switch code{
//            case "1": codeString = "Admin"
//            case "2": codeString = "Care Coordinator"
//            case "3": codeString = "Vendor"
//            case "4": codeString = "Care Team"
//            case "5": codeString = "Origin"
//            case "6": codeString = "Physician"
//            case "7": codeString = "Case Team"
//            case "8": codeString = "Organization"
//            case "9": codeString = "Case Team Manager"
//            case "10": codeString = "Nurse Practitioner"
//            default: codeString = ""
//        }
//        return codeString
//    }
    
}
