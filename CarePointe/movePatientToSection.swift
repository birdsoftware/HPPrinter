//
//  movePatientToSection.swift
//  CarePointe
//
//  Created by Brian Bird on 2/17/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//


import Foundation
import UIKit

extension UIViewController {

    func moveAppointmentToSection(SectionNumber: Int){
        //Used in:  PTVDetailViewController.swift
        //          AddNoteCompletPatientViewController.swift
        
        var appID = [[String]]() //empty array of arrays of type string
        var appPat = [[String]]()
        var appTime = [[String]]()
        var appDate = [[String]]()
        var appMessage = [[String]]()
        
        
        // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        //patientName = UserDefaults.standard.string(forKey: "patientName")!
        //appointmentID = UserDefaults.standard.string(forKey: "appointmentID")!
        
        let selectedRow = UserDefaults.standard.integer(forKey: "selectedRow")                      // "selectedRowMainDashBoard"
        let sectionForSelectedRow = UserDefaults.standard.integer(forKey: "sectionForSelectedRow")   //? main dashboard = let sectionOfSelectedRow = 1 //Accepted Patients
        let completedSection = SectionNumber // 2 = completed // 1 = accepted
        
        /*
         *  remove appointmentID from [sectionForSelectedRow][selectedRow]
         *  remove patients from [sectionForSelectedRow][selectedRow]
         *  append appointmentID to [completedSection][lastRow] [2][n]
         *  append patients to [completedSection][lastRow]
         *  replace whats in user defualts with new arrays
         */
        
        //Get up to date arrays for appID, appPat
    //------------------
        let appIDT = UserDefaults.standard.object(forKey: "appID")
        let appPatT = UserDefaults.standard.object(forKey: "appPat")
        let appTimeT = UserDefaults.standard.object(forKey: "appTime")
        let appDateT = UserDefaults.standard.object(forKey: "appDate")
        let appMessageT = UserDefaults.standard.object(forKey: "appMessage")
        
        if let appIDT = appIDT {
            appID = appIDT as! [[String]]
        }
        
        if let appPatT = appPatT {
            appPat = appPatT as! [[String]]
        }
        if let appTimeT = appTimeT {
            appTime = appTimeT as! [[String]]
        }
        
        if let appDateT = appDateT {
            appDate = appDateT as! [[String]]
        }
        
        if let appMessageT = appMessageT {
            appMessage = appMessageT as! [[String]]
        }
    //------------------
        let patientName = appPat[sectionForSelectedRow][selectedRow]
        let appointmentID = appID[sectionForSelectedRow][selectedRow]
        
        let associatedTime = appTime[sectionForSelectedRow][selectedRow]
        let associatedDay = appDate[sectionForSelectedRow][selectedRow]
        let associatedMessage = appMessage[sectionForSelectedRow][selectedRow]
        
        //remove appointmentID & patient from [sectionForSelectedRow][selectedRow]
        appID[sectionForSelectedRow].remove(at: selectedRow)
        appPat[sectionForSelectedRow].remove(at: selectedRow)
        appTime[sectionForSelectedRow].remove(at: selectedRow)
        appDate[sectionForSelectedRow].remove(at: selectedRow)
        appMessage[sectionForSelectedRow].remove(at: selectedRow)
        
        //append appointmentID & patient
        appID[completedSection].append(appointmentID)
        appPat[completedSection].append(patientName)
        appTime[completedSection].append(associatedTime)
        appDate[completedSection].append(associatedDay)
        appMessage[completedSection].append(associatedMessage)
    
        //update defaults from public arrays above
        //UserDefaults.standard.set(appSec, forKey: "appSec")
        UserDefaults.standard.set(appID, forKey: "appID")
        UserDefaults.standard.set(appPat, forKey: "appPat")
        UserDefaults.standard.set(appTime, forKey: "appTime")
        UserDefaults.standard.set(appDate, forKey: "appDate")
        UserDefaults.standard.set(appMessage, forKey: "appMessage")
        UserDefaults.standard.synchronize()
    }
}
