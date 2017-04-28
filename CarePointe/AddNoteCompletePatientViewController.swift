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
    
    var patient:String = ""
    var patientID: String = ""
    var userName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        if isKeyPresentInUserDefaults(key: "patientNameMainDashBoard") {
            patient = UserDefaults.standard.string(forKey: "patientNameMainDashBoard")!
            patientName.text = "Patient: " + patient
        }
        
        //patientID = UserDefaults.standard.string(forKey: "patientID")!
        
        // get profile user name
        if isKeyPresentInUserDefaults(key: "profileName") {
            userName = UserDefaults.standard.string(forKey: "profileName")!
        }
        if isKeyPresentInUserDefaults(key: "profileLastName") {
            userName += " " + UserDefaults.standard.string(forKey: "profileLastName")!
        }
        
        // get patientID
        patientID = self.returnSelectedPatientID()
        
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


    

    //
    //#MARK - Button Actions
    //
    
    @IBAction func completPatientButtonTapped(_ sender: Any) {
        
        // 1 MOVE PATIENT FROM ACCEPTED TO COMPLETED
            //search for  "filterAppointmentID" from user defaults in appID[1] and move to appID[2] // completed = 2
            let filterAppointmentID = UserDefaults.standard.string(forKey: "filterAppointmentID")
            self.moveFromAcceptedToCompletedFor(AppointmentID: filterAppointmentID!)
        
        // 2 UPDATE PATIENT FEED
        //                            times     dates   messageCreator  message     patientID
        self.insertPatientFeed(messageCreator: userName, message: messageTextBox.text, patientID: patientID, updatedFrom: "mobile", updatedType: "Update")
        
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
            let vc = storyboard.instantiateViewController(withIdentifier: "NavControllerMainDB") as UIViewController //PTV
            self.present(vc, animated: true, completion: nil)
            
        })
        
    }
    
    
}


