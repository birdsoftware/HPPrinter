//
//  GETForm.swift
//  CarePointe
//
//  Created by Brian Bird on 8/2/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//
// NOTE: EpisodeID below is from http://carepointe.cloud:4300/api/case/patientId/117581

import Foundation

class GETForm {
    
    func getFormByEpisode(token: String, episodeID: String, dispachInstance: DispatchGroup){
        
        var forms = Array<Dictionary<String,String>>()
        
        let nsurlAlerts = Constants.Patient.form + episodeID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//http://carepointe.cloud:4300/api/forms/episodeId/
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
            completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("GET Forms Error:\n\(String(describing: error))")
                    dispachInstance.leave() // API Responded
                    return
                } else {
                    
                    do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                        if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let vJSON = json["data"] as? [[String: Any]] {
                            if(vJSON.isEmpty == false){
                                for dict in vJSON {
                                    
                                    let assessment_name = dict["assessment_name"] as? String ?? ""//Form: "Initial Call - Form"
                                    let assessment_type = dict["assessment_type"] as? String ?? ""//Type: "Dynamic" or "File"
                                    let task_date = dict["task_date"] as? String ?? ""//Date:
                                    
                                    forms.append(["assessment_name":assessment_name,"assessment_type":assessment_type, "task_date":task_date])
                                }
                                
                                //careTeam = careTeams[0]
                                print("Forms: \(forms)")
                                UserDefaults.standard.set(forms, forKey: "RESTForms")
                                UserDefaults.standard.synchronize()
                                print("finished GET Forms for episodeID: \(episodeID)")
                                dispachInstance.leave() // API Responded
                            }
                            if(vJSON.isEmpty == true) {
                                UserDefaults.standard.set(forms, forKey: "RESTForms")
                                UserDefaults.standard.synchronize()
                                print("finished GET EMPTY Form for episodeID: \(episodeID)")
                            }
                        }
                    } catch {
                        print("Error deserializing Forms JSON: \(error)")
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
