//
//  GETNewQuestionnaire.swift
//  CarePointe
//
//  Created by Brian Bird on 6/23/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETQuestinnaire {
    
    func getCurQuestions(token: String, patientID: String, dispachInstance: DispatchGroup){
        //print("got here")
        var questinnaireData = Array<Dictionary<String,String>>()
        
        let nsurlAlerts = Constants.Patient.patientQuestionnaire + patientID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//http://carepointe.cloud:4300/api/rx/questionnaire/patientId/
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                                        completionHandler: { (data, response, error) -> Void in
                                            if (error != nil) {
                                                print("GET Current Questinnaire Error:\n\(String(describing: error))")
                                                dispachInstance.leave() // API Responded
                                                return
                                            } else {
                                                
                                                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                                                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                                        let vJSON = json["data"] as? [[String: Any]] {
                                                        if(vJSON.isEmpty == false){
                                                            for dict in vJSON {
                                                                
                                                                let qId = dict["id"] as? Int ?? 0
                                                                let comments = dict["comments"] as? String ?? ""
                                                                let question1 = dict["question1"] as? String ?? ""
                                                                let question2 = dict["question2"] as? String ?? ""
                                                                let question3 = dict["question3"] as? String ?? ""
                                                                let question4 = dict["question4"] as? String ?? ""
                                                                let question5 = dict["question5"] as? String ?? ""
                                                                let question6 = dict["question6"] as? String ?? ""
                                                                let question7 = dict["question7"] as? String ?? ""
                                                                let question8 = dict["question8"] as? String ?? ""
                                                                let question9 = dict["question9"] as? String ?? ""
                                                                let question10 = dict["question10"] as? String ?? ""
                                                                let added_by = dict["added_by"] as? Int ?? 0
                                                                let date_time = dict["date_time"] as? String ?? "" //"2017-05-13T19:54:01.000Z"
                                                                let comment1 = dict["comment1"] as? String ?? ""
                                                                let comment2 = dict["comment2"] as? String ?? ""
                                                                let comment3 = dict["comment3"] as? String ?? ""
                                                                let comment4 = dict["comment4"] as? String ?? ""
                                                                let comment5 = dict["comment5"] as? String ?? ""
                                                                let comment6 = dict["comment6"] as? String ?? ""
                                                                let comment7 = dict["comment7"] as? String ?? ""
                                                                let comment8 = dict["comment8"] as? String ?? ""
                                                                let comment9 = dict["comment9"] as? String ?? ""
                                                                let comment10 = dict["comment10"] as? String ?? ""
                                                                
                                                                let id = String(qId)
                                                                let aby = String(added_by)
                                                                
                                                                questinnaireData.append(["id":id,"comments":comments, "question1":question1, "question2":question2,
                                                                             "question3":question3,"question4":question4,"question5":question5,"question6":question6,
                                                                             "question7":question7,"question8":question8,"question9":question9,"question10":question10,
                                                                             "added_by":aby,
                                                                             "date_time":date_time,
                                                                             "comment1":comment1,"comment2":comment2,"comment3":comment3,"comment4":comment4,"comment5":comment5,
                                                                             "comment6":comment6,"comment7":comment7,"comment8":comment8,"comment9":comment9,"comment10":comment10])
                                                            }
                                                            
                                                            //print("Current questinnaire: \(questinnaireData)")
                                                            UserDefaults.standard.set(questinnaireData, forKey: "RESTCurrentQuestinnaire")
                                                            UserDefaults.standard.synchronize()
                                                            print("finished GET Current Questinnaire")
                                                            dispachInstance.leave() // API Responded
                                                        }
                                                        //ct came back empty?
                                                        //print("empty")
                                                    }
                                                } catch {
                                                    print("Error deserializing Current Questinnaire JSON: \(error)")
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

