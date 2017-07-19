//
//  RESTGETDocuments.swift
//  CarePointe
//
//  Created by Brian Bird on 5/5/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETDocuments {
    
    func getDocs(token: String, patientID: String, dispachInstance: DispatchGroup){

        var documents = Array<Dictionary<String,String>>()
        
        let nsurlAlerts = Constants.Patient.patientDocuments + patientID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//http://carepointe.cloud:4300/api/documents/patientId/
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
            completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("GET Documents Error:\n\(String(describing: error))")
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
                                    let fileName = dict["DocumentName"] as? String ?? ""
                                    let category = dict["DocumentCategory"] as? String ?? ""
                                    let FilePath = dict["FilePath"] as? String ?? ""
                                    let CreatedDateTime = dict["CreatedDateTime"] as? String ?? ""
                                    
                                    let eid = String(Episode_ID)
                                    
                                    documents.append(["Episode_ID":eid,"DocumentName":fileName, "DocumentCategory":category, "FilePath":FilePath, "CreatedDateTime":CreatedDateTime])

                                }
                                
                                //careTeam = careTeams[0]
                                print("documents: \(documents)")
                                UserDefaults.standard.set(documents, forKey: "RESTDocuments")
                                UserDefaults.standard.synchronize()
                                print("finished GET Documents")
                                dispachInstance.leave() // API Responded
                            }
                            //vitals came back empty?
                            print("empty")
                        }
                    } catch {
                        print("Error deserializing Documents JSON: \(error)")
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
