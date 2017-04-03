//
//  GETUsers.swift
//  CarePointe
//
//  Created by Brian Bird on 3/28/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETUsers {
    
    //http://stackoverflow.com/questions/43101357/find-duplicate-keys-in-two-arrays-of-dictionaries-to-update-old-array-dictionary/43101504#43101504
    //https://makeapppie.com/2014/08/21/the-swift-swift-tutorial-how-to-use-dictionaries-in-swift/
    //http://stackoverflow.com/questions/30418101/find-key-value-pair-in-an-array-of-dictionaries
    //
    
    func getUsers(token: String) {
        
        //var patients = [[String]]()
        var users = Array<Dictionary<String,String>>()
        
        var newUsers: [User] = []
        var oldUsers: [User] = []
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache",
           // "postman-token": "5b46169a-a62b-bd4a-e93f-5056ff0b508a"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://carepointe.cloud:4300/api/users")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                                        completionHandler: { (data, response, error) -> Void in
                                            if (error != nil) {
                                                print("Error when Attempting to GET Users:\(error!)")
                                                return
                                            } else {
                                                
                                                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                                                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                                        let JSON = json["data"] as? [[String: Any]] {
                                                        if(JSON.isEmpty == false){
                                                            
                                                            for dict in JSON {
                                                                
                                                                let userID = dict["User_ID"] as? Int ?? -1 //------
                                                                let userName = dict["UserName"] as? String ?? ""
                                                                let firstName = dict["FirstName"] as? String ?? ""
                                                                let lastName = dict["LastName"] as? String ?? ""
                                                                let emailID1 = dict["EmailID1"] as? String ?? ""
                                                                let roleType = dict["RoleType"] as? String ?? ""
                                                          
                                                                //clean out Int to String before placement into String dictionary
                                                                let uid = String(userID)
                                                                
                                                                //define dictionary literals
                                                                //http://stackoverflow.com/questions/30418101/find-key-value-pair-in-an-array-of-dictionaries
                                                                //users.append(["User_ID":uid, "UserName":userName, "FirstName":firstName, "LastName":lastName, "EmailID":emailID1, "RoleType":roleType])
                                                                
                                                                newUsers.append(User(id: uid, userName: userName, firstName: firstName, lastName:lastName, emailID1:emailID1, roleType:roleType))
                                                            }
                                                            
                                                            //print("\n users: \(users) \n")
                                                            
                                                            let oldUsersDefaults = UserDefaults.standard.array(forKey: "RESTusers") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
                                                            
                                                            //copy dictonary to class
                                                            for user in oldUsersDefaults {
                                                                let u = user["User_ID"]!
                                                                let uName = user["UserName"]!
                                                                let fName = user["FirstName"]!
                                                                let lName = user["LastName"]!
                                                                let eID = user["EmailID1"]!
                                                                let rType = user["RoleType"]!
                                                                
                                                                    oldUsers.append(User(id: u, userName: uName, firstName: fName, lastName:lName, emailID1:eID, roleType:rType))
                                                                
                                                            }
                                                            
                                                            //append new user, update user for matching ids
                                                            for user in newUsers {
                                                                var isNew = true
                                                                for oldUser in oldUsers {
                                                                    if oldUser.id == user.id {
                                                                        oldUser.userName = user.userName
                                                                        oldUser.firstName = user.firstName
                                                                        oldUser.lastName = user.lastName
                                                                        oldUser.emailID1 = user.emailID1
                                                                        oldUser.roleType = user.roleType
                                                                        isNew = false
                                                                    }
                                                                }
                                                                if isNew {
                                                                    oldUsers.append(user)
                                                                }
                                                            }
                                                            
                                                            //copy class to dictonary
                                                            for user in oldUsers {
                                                                
                                                                users.append(["User_ID":user.id, "UserName":user.userName, "FirstName":user.firstName, "LastName":user.lastName, "EmailID1":user.emailID1, "RoleType":user.roleType])
                                                                
                                                            }
                                                            
                                                            for user in newUsers {
                                                                print("users: \(user.id), \(user.userName), \(user.firstName), \(user.lastName), \(user.emailID1), \(user.roleType)")
                                                            }

                                                            
                                                            UserDefaults.standard.set(users, forKey: "RESTusers")
                                                            UserDefaults.standard.synchronize()
                                                            
                                                            print("finished GET Users!")
                                                            
                                                        }
                                                    }
                                                } catch {
                                                    print("Error deserializing Users JSON: \(error)")
                                                }

                                                /* //~~~~~~~~uncomment to run code now before this task completes
                                                DispatchQueue.main.async {
                                                    //code to run right now before this dataTask completes wait
                                                }
                                                 */ //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                            }
        })
        
        dataTask.resume()
        
    }
    
}

