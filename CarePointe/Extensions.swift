//
//  Extensions.swift
//  CarePointe
//
//  Created by Brian Bird on 7/26/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

extension UserDefaults {
    var hasSpotifyToken:Bool {
        return ntuc() != nil
    }
    
    func ntuc() -> Array<Dictionary<String,String>>  {
        return object(forKey: "RESTCase") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
    }
    
    func episodeNotes() -> Array<Dictionary<String,String>>  {
        return object(forKey:  "RESTEpisodeNotes") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
    }
    
    func edVisits() -> Array<Dictionary<String,String>>  {
        return object(forKey:  "RESTEDVisits") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
    }

    func edVisitsCount() -> Array<Dictionary<String,String>>  {
        return object(forKey:  "RESTEDVisitsCount") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
    }

    func saverestCase(token:String) {
        set(token, forKey:"")
        synchronize()
    }
}
