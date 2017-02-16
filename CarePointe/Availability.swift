//
//  Availability.swift
//  CarePointe
//
//  Created by Brian Bird on 2/8/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation


class Availability : NSObject{
    
    var AvailabilityDay: String
    var AvailabilityFromTime: String
    var AvailabilityToTime: String
    
    init(withDay d : String, andFromTime ft : String, andToTime tt: String) {
        
        AvailabilityDay = d
        AvailabilityFromTime = ft
        AvailabilityToTime = tt
    }
    
    init(withCoder coder : NSCoder) {
        
        AvailabilityDay = coder.decodeObject(forKey: "AvailabilityDay") as! String
        AvailabilityFromTime = coder.decodeObject(forKey: "AvailabilityFromTime") as! String
        AvailabilityToTime = coder.decodeObject(forKey: "AvailabilityToTime") as! String
    }
    
    func encodeWithCoder(_ coder : NSCoder) {
        coder.encode(AvailabilityDay, forKey: "AvailabilityDay")
        coder.encode(AvailabilityFromTime, forKey: "AvailabilityFromTime")
        coder.encode(AvailabilityToTime, forKey: "AvailabilityToTime")
    }
    
}
