//
//  GETEpisodeNotes.swift
//  CarePointe
//
//  Created by Brian Bird on 7/25/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class GETEpisode {
    
    func getEpisodeNotes(token: String, episodeID: String, dispachInstance: DispatchGroup){
        
        var episodeNotes = Array<Dictionary<String,String>>()
        
        let nsurlAlerts = Constants.Case.episodeNotes + episodeID
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: nsurlAlerts)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//"http://carepointe.cloud:4300/api/case/episodeNotes/episodeId/"
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print("GET EpisodeNotes Error:\n\(String(describing: error))")
                        dispachInstance.leave() // API Responded
                        return
                    } else {
                        
                        do {
                            if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let vJSON = json["data"] as? [[String: Any]] {
                                if(vJSON.isEmpty == false){
                                    for dict in vJSON {
                                        
                                        let episode_notes = dict["episode_notes"] as? String ?? ""
                                        
                                        episodeNotes.append(["episode_notes":episode_notes])
                                    }
                                    
                                    UserDefaults.standard.set(episodeNotes, forKey: "RESTEpisodeNotes")
                                    UserDefaults.standard.synchronize()
                                    print("finished GET EpisodeNotes")
                                    dispachInstance.leave() // API Responded
                                }
                                //vitals came back empty?
                                print("empty")
                            }
                        } catch {
                            print("Error deserializing EpisodeNotes JSON: \(error)")
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
