//
//  RESTGETUsers.swift
//  CarePointe
//
//  Created by Brian Bird on 3/28/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETRecipients {
    
    //http://stackoverflow.com/questions/43101357/find-duplicate-keys-in-two-arrays-of-dictionaries-to-update-old-array-dictionary/43101504#43101504
    //https://makeapppie.com/2014/08/21/the-swift-swift-tutorial-how-to-use-dictionaries-in-swift/
    //http://stackoverflow.com/questions/30418101/find-key-value-pair-in-an-array-of-dictionaries
    //
    
    func getInboxUsers(token: String) {
        
        //var patients = [[String]]()
        var users = Array<Dictionary<String,String>>()
        
        //var newUsers: [User] = []
        //var oldUsers: [User] = []
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
            // "postman-token": "5b46169a-a62b-bd4a-e93f-5056ff0b508a"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: Constants.Message.inboxUsersList)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//http://carepointe.cloud:4300/api/inbox/users
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                                        completionHandler: { (data, response, error) -> Void in
                                            if (error != nil) {
                                                print("Error when Attempting to GET Inbox Users:\(error!)")
                                                return
                                            } else {
                                                
                                                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                                                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                                        let JSON = json["data"] as? [[String: Any]] {
                                                        if(JSON.isEmpty == false){
                                                            
                                                            for dict in JSON {
                                                                
                                                                let firstName = dict["FirstName"] as? String ?? ""  //Combine with lastName
                                                                let company = dict["Company"] as? String ?? ""
                                                                let userID = dict["User_ID"] as? Int ?? -1 //------ //Convert to string
                                                                let lastName = dict["LastName"] as? String ?? ""    //Combine with firstName
                                                                let phoneNumber = dict["phone_number"] as? String ?? ""
                                                                let roleType = dict["RoleType"] as? String ?? ""
                                                                
                                                                let firstLastName = firstName + " " + lastName
                                                                //clean out Int to String before placement into String dictionary
                                                                let uid = String(userID)
                                                                
                                                                //define dictionary literals
                                                                //http://stackoverflow.com/questions/30418101/find-key-value-pair-in-an-array-of-dictionaries
                                                                users.append(["FirstLastName":firstLastName, "Company":company, "User_ID":uid, "phone_number":phoneNumber, "RoleType":roleType])
                                                                
                                                                //newUsers.append(User(firstLastName: firstLastName, company:company, id: uid, userName: userName, roleType:roleType))
                                                            }
                                                            
                                                            //
                                                            //Check if old users exist and UPDATE or APPEND
                                                            //
//                                                            let oldUsersDefaults = UserDefaults.standard.array(forKey: "RESTInboxUsers") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
//                                                            
//                                                            //copy dictonary to class
//                                                            for user in oldUsersDefaults {
//                                                                
//                                                                let fLName = user["FirstLastName"]!
//                                                                let co = user["Company"]!
//                                                                let u = user["User_ID"]!
//                                                                let uName = user["UserName"]!
//                                                                let rType = user["RoleType"]!
//                                                                
//                                                                oldUsers.append(User(firstLastName: fLName, company:co, id: u, userName: uName, roleType:rType))
//                                                                
//                                                            }
//                                                            
//                                                            //
//                                                            //UPDATE user for matching ids or APPEND NEW user
//                                                            //
//                                                            for user in newUsers {
//                                                                var isNew = true
//                                                                for oldUser in oldUsers {
//                                                                    if oldUser.id == user.id {
//                                                                        oldUser.userName = user.userName
//                                                                        oldUser.firstLastName = user.firstLastName
//                                                                        //oldUser.firstName = user.firstName
//                                                                        //oldUser.lastName = user.lastName
//                                                                        oldUser.company = user.company
//                                                                        oldUser.roleType = user.roleType
//                                                                        isNew = false
//                                                                    }
//                                                                }
//                                                                if isNew {
//                                                                    oldUsers.append(user)
//                                                                }
//                                                            }
//                                                            
//                                                            //copy class to dictonary
//                                                            for user in oldUsers {
//                                                                // firstLastName: fLName, company:co, id: u, userName: uName, roleType:rType
//                                                                users.append(["FirstLastName":user.firstLastName, "Company":user.company, "User_ID":user.id, "UserName":user.userName, "RoleType":user.roleType])
//                                                                
//                                                            }
//                                                            
//                                                            for user in newUsers {
//                                                                //print("users: \(user.id), \(user.userName), \(user.firstName), \(user.lastName), \(user.emailID1), \(user.roleType)")
//                                                                print("users: \(user.id), \(user.userName), \(user.firstLastName), \(user.emailID1), \(user.roleType)")
//                                                            }
                                                            
                                                            
                                                            UserDefaults.standard.set(users, forKey: "RESTInboxUsers")
                                                            UserDefaults.standard.synchronize()
                                                            
                                                            print("finished GET Inbox Users")
                                                            
                                                        }
                                                    }
                                                } catch {
                                                    print("Error deserializing Inbox Users JSON: \(error)")
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


