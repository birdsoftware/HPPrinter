//
//  GETInboxMessages.swift
//  CarePointe
//
//  Created by Brian Bird on 5/25/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETInboxMessages {
    
    func getInboxMessages(token: String, userID: String, dispachInstance: DispatchGroup){
        
        var inbox = Array<Dictionary<String,String>>()
        
        //for loop
        var Subject = ""
        var message =  ""
        var IsRead =  ""
        var fullDateString =  ""
        var SendBy = 0
        var s = ""
        var str = ""
        var date = ""
        var time = ""
        
        let nsurlAlerts = Constants.Message.fromInbox + userID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/inbox/userId/"
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
            completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("GET user inbox Error:\n\(String(describing: error))")
                    dispachInstance.leave() // API Responded
                    return
                } else {
                    
                    do {
                        if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let vJSON = json["data"] as? [[String: Any]] {
                            if(vJSON.isEmpty == false){
                                for dict in vJSON {
                                    
                                    let ID = dict["ID"] as? Int ?? 0
                                    Subject = dict["Subject"] as? String ?? ""
                                    message = dict["Msg_desc"] as? String ?? ""
                                    IsRead = dict["IsRead"] as? String ?? ""
                                    fullDateString = dict["CreatedDateTime"] as? String ?? ""
                                    SendBy = dict["SendBy"] as? Int ?? 0
                                    s = String(SendBy)
                                    let id = String(ID)
                                    
                                    //REMOVE HTML TAGS
                                    str = message.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                                    
                                    //RETURN Date Time using "2017-05-25T04:00:00.000Z"
                                    if fullDateString.isEmpty == false {
                                        
                                        //1.Date mm/dd/yy
                                        date = self.convertDateStringToDate(longDate: fullDateString)
                                        //2. time
                                        time = self.returnTimeFromString(fullDateString: fullDateString)//formatter.string(from:date!)
                                    }
                                    
                                    inbox.append(["SendBy":s, "Subject":Subject, "message":str,
                                                    "CreatedDate":date, "CreatedTime":time,"IsRead":IsRead,"ID":id])
                                }
                                
                                UserDefaults.standard.set(inbox, forKey: "RESTUserInbox")
                                UserDefaults.standard.synchronize()
                                print("finished GET user inbox")
                                dispachInstance.leave() // API Responded
                            }
                            //patient referral came back empty?
                            print("user inbox - empty")
                        }
                    } catch {
                        print("Error deserializing user inbox JSON: \(error)")
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
    
    func convertDateStringToDate(longDate: String) -> String{
        /* INPUT: longDate = "2017-01-27T05:00:00.000Z"
         * OUTPUT: "1/26/17"
         * date_format_you_want_in_string from
         * http://userguide.icu-project.org/formatparse/datetime
         */
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: longDate)
        
        if date != nil {

            //let formatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = TimeZone(identifier: "America/New_York")
            let dateShort = dateFormatter.string(from: date!)
            
            return dateShort
            
        } else {
            return longDate
        }
    }
    
    func returnTimeFromString(fullDateString: String) -> String{
        
        let startIndex = fullDateString.index(fullDateString.startIndex, offsetBy: 11)//->"04:00:00.000Z"
        let truncatedFront = fullDateString.substring(from: startIndex)
        let endIndex = truncatedFront.index(truncatedFront.endIndex, offsetBy: -8)//Remove ":00.000Z"
        let truncatedTime = truncatedFront.substring(to: endIndex)//->"04:00" or "19:14"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.date(from: truncatedTime)

        formatter.timeStyle = .short
        
        return formatter.string(from: time!)
    }
    
}
