//
//  RESTGETReferrals.swift
//  CarePointe
//
//  Created by Brian Bird on 4/30/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETReferrals {
    
    func getAllReferrals(token: String, userID: String){
        
        var referrals = Array<Dictionary<String,String>>()
        
        let headers = [
            "authorization":token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://carepointe.cloud:4300/api/referrals/userId/"+userID)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print("Error when Attempting to GET All Referals:\(error!)")
                        //dispachInstance.leave() // API Responded
                        return
                    } else {
                        
                        do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                            if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let JSON = json["data"] as? [[String: Any]] {
                                if(JSON.isEmpty == false){
                                    
                                    for dict in JSON {
                                        
                                        let patientID = dict["Patient_ID"] as? Int ?? -1
                                        let patientName = dict["Patient_Name"] as? String ?? ""             //
                                        let carePlanID = dict["Care_Plan_ID"] as? Int ?? -1
                                        let episodeID = dict["Episode_ID"] as? Int ?? -1
                                        let serviceProviderID = dict["ServiceProvider_ID"] as? Int ?? -1
                                        let provideruserid = dict["provideruserid"] as? Int ?? -1
                                        let startDate = dict["StartDate"] as? String ?? ""                  //
                                        let datehhmm = dict["date_hhmm"] as? String ?? ""
                                        let bookMinutes = dict["book_minutes"] as? String ?? ""
                                        let serviceCategory = dict["ServiceCategory"] as? String ?? ""
                                        let status = dict["Status"] as? String ?? ""                        //
                                        let summary = dict["Summary"] as? String ?? ""
                                        let patientNotes = dict["patient_notes"] as? String ?? ""
                                        let bookType = dict["book_type"] as? String ?? ""
                                        let bookPurpose = dict["book_purpose"] as? String ?? ""
                                        let locationType = dict["location_type"] as? String ?? ""
                                        let bookPlace = dict["book_place"] as? String ?? ""
                                        let bookAddress = dict["book_address"] as? String ?? ""
                                        let dateofcollection = dict["dateofcollection"] as? String ?? ""
                                        let attachmentDoc = dict["Attachment_doc"] as? String ?? ""
                                        let isHomeassessment = dict["Is_homeassessment"] as? String ?? ""
                                        let isActive = dict["IsActive"] as? String ?? ""
                                        let createdDateTime = dict["CreatedDateTime"] as? String ?? ""
                                        let updatedDateTime = dict["UpdatedDateTime"] as? String ?? ""
                                        let createdByName = dict["CreatedBy_name"] as? String ?? ""
                                        let providerName = dict["provider_name"] as? String ?? ""

                                        
                                        let pid = String(patientID)
                                        let cpid = String(carePlanID)
                                        let eid = String(episodeID)
                                        let spid = String(serviceProviderID)
                                        let puid = String(provideruserid)
                                        
                                        //define dictionary literals

                                        referrals.append(["alertid":pid, "Patient_Name":patientName, "Care_Plan_ID":cpid, "Episode_ID":eid,
                                                          "ServiceProvider_ID":spid, "provideruserid":puid, "StartDate":startDate, "date_hhmm":datehhmm, "book_minutes":bookMinutes, "ServiceCategory":serviceCategory, "Status":status, "Summary":summary, "patient_notes":patientNotes, "book_type":bookType, "book_purpose":bookPurpose, "location_type":locationType, "book_place":bookPlace, "book_address":bookAddress, "dateofcollection":dateofcollection, "Attachment_doc":attachmentDoc, "Is_homeassessment":isHomeassessment, "IsActive":isActive, "CreatedDateTime":createdDateTime, "UpdatedDateTime":updatedDateTime, "CreatedBy_name":createdByName, "provider_name":providerName])
                                    }
                                    
                                    UserDefaults.standard.set(referrals, forKey: "RESTAllReferrals")
                                    UserDefaults.standard.synchronize()
                                    
                                    print("finished GET All Referals")
                                    
                                }
                                //No Referrals
                                //JSON.isEmpty == true
                                print("finished GET All Referals - No referrals to GET")
                            }
                        } catch {
                            print("Error deserializing All Referals JSON: \(error)")
                            //dispachInstance.leave() // API Responded
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
