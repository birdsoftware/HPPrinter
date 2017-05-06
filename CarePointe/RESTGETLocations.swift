//
//  RESTGETLocations.swift
//  CarePointe
//
//  Created by Brian Bird on 5/4/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETLocations {
    
    func getLocations(token: String, patientID: String, dispachInstance: DispatchGroup){
        print("locations patientID: \(patientID)")
        var locations = Array<Dictionary<String,String>>()
        
        let nsurlAlerts = "http://carepointe.cloud:4300/api/location/patientId/" + patientID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print("GET locations Error:\n\(String(describing: error))")
                        dispachInstance.leave() // API Responded
                        return
                    } else {
                        
                        do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                            if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let vJSON = json["data"] as? [[String: Any]] {
                                if(vJSON.isEmpty == false){
                                    for dict in vJSON {
                                        
                                        let Episode_ID = dict["Episode_ID"] as? Int ?? 0
                                        let Patient_ID = dict["Patient_ID"] as? Int ?? 0
                                        let TransferToFacility = dict["TransferToFacility"] as? String ?? "" //badge //Case - Locations
                                        let TransferFromFacility = dict["TransferFromFacility"] as? String ?? "" //Case - Locations
                                        let AdmittanceDate = dict["AdmittanceDate"] as? String ?? ""  //Case - Locations
                                        
                                        //let RoomNo = dict["RoomNo"] as? String ?? ""
                                        //let ReasonForTransfer = dict["ReasonForTransfer"] as? String ?? ""
                                        let CarePrograms = dict["CarePrograms"] as? String ?? "" //badge //program - case
                                        let Disease = dict["Disease"] as? String ?? ""           //badge //case
                                        
                                        //case
                                        let ICD_9s = dict["ICD_9s"] as? String ?? ""
                                        let Diagnosis = dict["Diagnosis"] as? String ?? ""
                                        let EpisodeSummary = dict["EpisodeSummary"] as? String ?? "" //summary case
                                        let ComplexityLevel = dict["ComplexityLevel"] as? String ?? "" //need for acuity in Case Tab
                                        
                                        let eid = String(Episode_ID)
                                        let pid = String(Patient_ID)
                                        
                                        locations.append(["Episode_ID":eid, "Patient_ID":pid, "TransferToFacility":TransferToFacility,
                                                          "TransferFromFacility":TransferFromFacility, "AdmittanceDate":AdmittanceDate,
                                                          "CarePrograms":CarePrograms, "Disease":Disease, "ICD_9s":ICD_9s, "Diagnosis":Diagnosis,
                                                          "EpisodeSummary":EpisodeSummary, "ComplexityLevel":ComplexityLevel])
                                        
                                    }
                                    
                                    //careTeam = careTeams[0]
                                    print("v: \(locations)")
                                    UserDefaults.standard.set(locations, forKey: "RESTLocations")
                                    UserDefaults.standard.synchronize()
                                    print("finished GET locationse ")
                                    dispachInstance.leave() // API Responded
                                }
                                // came back empty?
                                print("locations came back empty")
                            }
                        } catch {
                            print("Error deserializing locationse JSON: \(error)")
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
}
