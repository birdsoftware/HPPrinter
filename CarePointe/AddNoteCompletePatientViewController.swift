//
//  AddNoteCompletePatientViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/16/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class AddNoteCompletePatientViewController: UIViewController {
    
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var messageTextBox: UITextView!
    
    
//    var appID = [[String]]() //empty array of arrays of type string
//    var appPat = [[String]]()
//    var appTime = [[String]]()
//    var appDate = [[String]]()
//    var appMessage = [[String]]()

    //var patient = "Temporary"

    override func viewDidLoad() {
        super.viewDidLoad()

        // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        let patient = UserDefaults.standard.string(forKey: "patientNameMainDashBoard")!
        patientName.text = "Patient: " + patient
        
        // UI setup
        messageTextBox.layer.borderWidth = 1.0
        messageTextBox.layer.borderColor = UIColor(hex: 0xD7D7D7).cgColor//uses custom Class in hexColor.swift
        messageTextBox.layer.cornerRadius = 5
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white // "< Back" is white color in nav controler
        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    // This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
//    func movePatientToSection(SectionNumber: Int){
//        // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
//        let selectedRow = UserDefaults.standard.integer(forKey: "selectedRowMainDashBoard")
//        let sectionForSelectedRow = 1 //Accepted Patients //UserDefaults.standard.integer(forKey: "sectionForSelectedRow")
//        let completedSection = SectionNumber // 2 = completed // 1 = accepted
//        
//        /*
//         *  remove appointmentID from [sectionForSelectedRow][selectedRow]
//         *  remove patients from [sectionForSelectedRow][selectedRow]
//         *  append appointmentID to [completedSection][lastRow] [2][n]
//         *  append patients to [completedSection][lastRow]
//         *  replace whats in user defualts with new arrays
//         */
//        
//        //Get up to date arrays for appID, appPat
//        GetAppointmentFromDefaults()
//        let appointmentID = appID[sectionForSelectedRow][selectedRow]
//        let patientName = patient //appPat[sectionForSelectedRow][selectedRow]
//        let associatedTime = appTime[sectionForSelectedRow][selectedRow]
//        let associatedDay = appDate[sectionForSelectedRow][selectedRow]
//        let associatedMessage = appMessage[sectionForSelectedRow][selectedRow]
//        
//        //remove appointmentID & patient from [sectionForSelectedRow][selectedRow]
//        appID[sectionForSelectedRow].remove(at: selectedRow)
//        appPat[sectionForSelectedRow].remove(at: selectedRow)
//        appTime[sectionForSelectedRow].remove(at: selectedRow)
//        appDate[sectionForSelectedRow].remove(at: selectedRow)
//        appMessage[sectionForSelectedRow].remove(at: selectedRow)
//        
//        //append appointmentID & patient
//        appID[completedSection].append(appointmentID)
//        appPat[completedSection].append(patientName)
//        appTime[completedSection].append(associatedTime)
//        appDate[completedSection].append(associatedDay)
//        appMessage[completedSection].append(associatedMessage)
//        
//        //update defaults from public arrays above
//        //UserDefaults.standard.set(appSec, forKey: "appSec")
//        UserDefaults.standard.set(appID, forKey: "appID")
//        UserDefaults.standard.set(appPat, forKey: "appPat")
//        UserDefaults.standard.set(appTime, forKey: "appTime")
//        UserDefaults.standard.set(appDate, forKey: "appDate")
//        UserDefaults.standard.set(appMessage, forKey: "appMessage")
//        
//    }
//
//    func GetAppointmentFromDefaults(){
//        
//        let appIDT = UserDefaults.standard.object(forKey: "appID")
//        let appPatT = UserDefaults.standard.object(forKey: "appPat")
//        let appTimeT = UserDefaults.standard.object(forKey: "appTime")
//        let appDateT = UserDefaults.standard.object(forKey: "appDate")
//        let appMessageT = UserDefaults.standard.object(forKey: "appMessage")
//        
//        if let appIDT = appIDT {
//            appID = appIDT as! [[String]]
//        }
//        
//        if let appPatT = appPatT {
//            appPat = appPatT as! [[String]]
//        }
//        //------------------------------ time, date, message needed ViewController in main dash -------//
//        if let appTimeT = appTimeT {
//            appTime = appTimeT as! [[String]]
//        }
//        
//        if let appDateT = appDateT {
//            appDate = appDateT as! [[String]]
//        }
//        
//        if let appMessageT = appMessageT {
//            appMessage = appMessageT as! [[String]]
//        }
//    }


    //
    //#MARK - Button Actions
    //
    
    @IBAction func completPatientButtonTapped(_ sender: Any) {
        
        let completed = 2
        //self.movePatientToSection(SectionNumber: completed)
        self.moveAppointmentToSection(SectionNumber: completed)
        
        // ANIMATE "Patient Complete" TOAST then unwind segue back to MAIN dashboard
        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
            
            self.view.makeToast("Patient Complete", duration: 1.1, position: .center)
            
        }, completion: { finished in
            
                //unwind segue after animating - DID NOT UPDATE LIST VIEW
                //1. palce "@IBAction func unwind...(segue: UIStoryboardSegue) {}" in view controller you want to unwind too
                //2. In storyboard connect this view () -> to [exit]
                //   In storyboard set unwind segue identifier: "unwindToMainDB"
                //                     Action: "unwind..."
                //3. Trigger unwind segue programmatically (below)
                //self.performSegue(withIdentifier: "unwindToMainDB", sender: self)
            
            // Instantiate a view controller from Storyboard and present it
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NavControllerMainDB") as UIViewController
            self.present(vc, animated: true, completion: nil)
            
        })
        
    }
    
    
}


