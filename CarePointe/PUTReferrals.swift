//
//  PUTReferrals.swift
//  CarePointe
//
//  Created by Brian Bird on 6/22/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class PUTReferrals {
    
    func putReferralNow(token: String, carePlanID: String, referral:Dictionary<String,String>, dispachInstance: DispatchGroup) {
        
        let headers = [
            "authorization":token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let parameters = [
            "StartDate": referral["StartDate"]!,        //"2017-05-26T04:00:00.000Z"
            "date_hhmm": referral["date_hhmm"]!,        //"01:30"
            "book_minutes":referral["book_minutes"]!,   //"30"
            "Status":referral["Status"]!,               //"Pending"
            "book_type":referral["book_type"]!,         //"Surgery Consultation"
            "book_purpose":referral["book_purpose"]!,   //"notes"
            "book_place":referral["book_place"]!,        //"AZPC"
            "pre_authorization":referral["pre_authorization"]!,
            "Attachment_doc":referral["Attachment_doc"]!,
            "location_type":referral["location_type"]!
            ] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        //print(String(data: postData, encoding: .utf8)!) //{test@test.com, test123456}
        let request = NSMutableURLRequest(url: NSURL(string: Constants.Patient.putReferral + carePlanID)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//http://carepointe.cloud:4300/api/referrals/careplanid/
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                //let errorLocalDes = error?.localizedDescription
                print("Error when Attempting to PUT New Referral Update: \(error!)") //Internet connection offline. -1009

                UserDefaults.standard.set(false, forKey: "APIPUTReferralsSuccess")
                UserDefaults.standard.synchronize()
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
                            
                            UserDefaults.standard.set(true, forKey: "APIPUTReferralsSuccess")
                            UserDefaults.standard.synchronize()
                            
                            print("finished PUT New Referral Update")
                        }
                        dispachInstance.leave() // API Responded
                    }
                } catch {
                    print("Error deserializing PUT New Referral Update JSON: \(error)")
                    UserDefaults.standard.set(false, forKey: "APIPUTReferralsSuccess")
                    UserDefaults.standard.synchronize()
                    dispachInstance.leave() // API Responded
                }
            }
        })
        dataTask.resume()
    }
}
