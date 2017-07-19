//
//  GETUpdateIsRead.swift
//  CarePointe
//
//  Created by Brian Bird on 6/5/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class UserRead {
    
    func MessageID(token: String, messageId: String, dispachInstance: DispatchGroup) {
        
        let headers = [
            "authorization":token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: Constants.Message.isRead + messageId)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/inbox/messageId/"
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                print("Error when Attempting GET isRead == Y message: \(error!)")
                
                dispachInstance.leave() // API Responded
                
            } else {
                
                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let type = json["type"] as? Bool{
                        if(type == true){
                            
                            print("finished GET isRead == Y message")
                        }
                        dispachInstance.leave() // API Responded
                    }
                } catch {
                    print("Error deserializing GET isRead == Y message JSON: \(error)")
                    
                    dispachInstance.leave() // API Responded
                }
            }
        })
        dataTask.resume()
    }
}
