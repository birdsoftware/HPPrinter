//
//  Appointments.swift
//  CarePointe
//
//  Created by Brian Bird on 2/14/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class Appointments : NSObject{
    
    var AppointmentID: String          //90213
    var AppointmentDay: String
    var AppointmentTime: String
    var AppointmentPatient: String
    var AppointmentMessage: String
    var AppointmentStatus: String   //new/pending (orange, scheduled (green), completed (gray)
    
    init(withID id : String, andDay d : String, andTime t: String, andPatient p: String,
        andMessage m: String, andStatus s: String) {
        
        AppointmentID = id
        AppointmentDay = d
        AppointmentTime = t
        AppointmentPatient = p
        AppointmentMessage = m
        AppointmentStatus = s
    }
    
    init(withCoder coder : NSCoder) {
        
        AppointmentID = coder.decodeObject(forKey: "AppointmentID") as! String
        AppointmentDay = coder.decodeObject(forKey: "AppointmentDay") as! String
        AppointmentTime = coder.decodeObject(forKey: "AppointmentTime") as! String
        AppointmentPatient = coder.decodeObject(forKey: "AppointmentPatient") as! String
        AppointmentMessage = coder.decodeObject(forKey: "AppointmentMessage") as! String
        AppointmentStatus = coder.decodeObject(forKey: "AppointmentStatus") as! String
    }
    
    func encodeWithCoder(_ coder : NSCoder) {
        
        coder.encode(AppointmentID, forKey: "AppointmentID")
        coder.encode(AppointmentDay, forKey: "AppointmentDay")
        coder.encode(AppointmentTime, forKey: "AppointmentTime")
        coder.encode(AppointmentPatient, forKey: "AppointmentPatient")
        coder.encode(AppointmentMessage, forKey: "AppointmentMessage")
        coder.encode(AppointmentStatus, forKey: "AppointmentStatus")
    }
    
}
