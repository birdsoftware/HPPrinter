//
//  POSTInboxMessage.swift
//  CarePointe
//
//  Created by Brian Bird on 6/1/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class POSTMessage {
    
    func sendMessage(token: String, message:Dictionary<String,String>, SendTo: [Int], dispachInstance: DispatchGroup) {
        
        let sendBy = Int(message["SendBy"]!)!
        
        let headers = [
            "authorization":token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let parameters = [
            "Subject": message["Subject"]!,  //requires String
            "Msg_desc": message["Msg_desc"]!,//requires String
            "SendBy": sendBy,     //requires Int 337
            "SendTo": SendTo,     //requires [Int] [337]
            ] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        //print(String(data: postData, encoding: .utf8)!) //{test@test.com, test123456}
        
        let request = NSMutableURLRequest(url: NSURL(string: Constants.Message.postNewMessage)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/inbox"
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                print("Error when Attempting to POST/send messageInbox: \(error!)") //The Internet connection appears to be offline. -1009
                UserDefaults.standard.set(false, forKey: "APIsendMessageSuccess")
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
                            
                            UserDefaults.standard.set(true, forKey: "APIsendMessageSuccess")
                            UserDefaults.standard.synchronize()
                            
                            print("finished POST messageInbox")
                        }
                        dispachInstance.leave() // API Responded
                    }
                } catch {
                    print("Error deserializing POST/send messageInbox JSON: \(error)")
                    UserDefaults.standard.set(false, forKey: "APIsendMessageSuccess")
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
