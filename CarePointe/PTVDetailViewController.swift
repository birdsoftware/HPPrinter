//
//  PTVDetailViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/31/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PTVDetailViewController: UIViewController {

    //segment
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //container views
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var containerView2: UIView!
    @IBOutlet weak var containerView3: UIView!
    @IBOutlet weak var containerView4: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    //Segue from Referrals
    //var segueStoryBoardName: String! //patientList -> nil, Referrals -> "Refferal"
    //var segueStoryBoardID: String!
    var storyBoardName: String!
    
    var patientName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get directly
        //https://makeapppie.com/2015/02/04/swift-swift-tutorials-passing-data-in-tab-bar-controllers/
        let tbvc = self.tabBarController as! PatientTabBarController
        storyBoardName = tbvc.segueStoryBoardName
        //print("<<<<PTVDetailViewController segueStoryBoardName: \(storyBoardName)")
        backButton.layer.cornerRadius = 5

        containerView1.isHidden = false
        containerView2.isHidden = true
        containerView3.isHidden = true
        containerView4.isHidden = true
        
        // store specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        patientName = UserDefaults.standard.string(forKey: "patientName")!
        //patientNameLabel.text = patientName + "'s Information"
        
        // show/hide accept/decline/complete buttons based on status
        let patientStatus = UserDefaults.standard.string(forKey: "patientStatus")
        updatePatientView(status: patientStatus!)
        
        // Setup sement control font and font size
        let attr = NSDictionary(object: UIFont(name: "Futura", size: 15.0)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        

    }
    
    
    //
    //#MARK - Supporting functions
    //

    func updatePatientView(status: String){
        
    }
    
    
    //#MARK - Actions
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            containerView1.isHidden = false
            containerView2.isHidden = true
            containerView3.isHidden = true
            containerView4.isHidden = true
        case 1:
            containerView1.isHidden = true
            containerView2.isHidden = false
            containerView3.isHidden = true
            containerView4.isHidden = true
        case 2:
            containerView1.isHidden = true
            containerView2.isHidden = true
            containerView3.isHidden = false
            containerView4.isHidden = true
        case 3:
            containerView1.isHidden = true
            containerView2.isHidden = true
            containerView3.isHidden = true
            containerView4.isHidden = false
        default:
            break;
        }
        
    }
    
    
    //
    // #MARK - buttons
    //
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if storyBoardName != nil {
            if storyBoardName! == "Refferal" {
                self.performSegue(withIdentifier: "patientToReferral", sender: self)
//            if segueStoryBoardName == "Refferal" {
            //toViewController.segueStoryBoardID = "Refferal"
                //let storyboard = UIStoryboard(name: "Refferal", bundle: nil)
                //let vc = storyboard.instantiateViewController(withIdentifier: "referralVC") as UIViewController
                //vc.navigationController?.pushViewController(vc, animated: false)
                //self.present(vc, animated: false, completion: nil)
            }
        
        } else {
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "PatientList", bundle: nil)//"PatientList" //Refferal
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientListView") as UIViewController//"PatientListView" //referralVC TODO: fis segue values needed for referal
        //vc.navigationController?.pushViewController(vc, animated: false)
        self.present(vc, animated: false, completion: nil)
        }
       
            
    }
    
    
    
//    @IBAction func declinePatientButtonTapped(_ sender: Any) {
//        
//        // Show Alert, ask why, get leave a note text, show [Submit] [Cancel] buttons
//        let alert = UIAlertController(title: "Decline Patient",
//                                      message: "Submit decline patient for "+patientName,
//                                      preferredStyle: .alert)
//        
//        // Submit button
//        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
//            // get patientID
//            let patientID = self.returnSelectedPatientID()
//            var userName:String = ""
//            
//            // get profile user name
//            if self.isKeyPresentInUserDefaults(key: "profileName") {
//                userName = UserDefaults.standard.string(forKey: "profileName")!
//            }
//            if self.isKeyPresentInUserDefaults(key: "profileLastName") {
//                userName += " " + UserDefaults.standard.string(forKey: "profileLastName")!
//            }
//            
//            // Get 1st TextField's text
//            let declineMessage = "Patient \(patientID) declined by \(userName). " + alert.textFields![0].text! //print(textField)
//            
//            // 1 MOVE PATIENT FROM NEW TO COMPLETED
//            let completed = 2 //0 new,1 accept,2 completed
//            self.moveAppointmentToSection(SectionNumber: completed)
//            
//            // 2 UPDATE PATIENT FEED
//            //      times   dates   messageCreator  message     patientID
//            self.insertPatientFeed(messageCreator: userName, message: declineMessage, patientID: patientID, updatedFrom: "mobile", updatedType: "Update")
//            
//            
//            // 3. Instantiate a view controller from Storyboard and present it
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
//            self.present(vc, animated: false, completion: nil)
//        })
//        
//        // Cancel button
//        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
//        
//        // Add 1 textField and customize it
//        alert.addTextField { (textField: UITextField) in
//            textField.keyboardAppearance = .dark
//            textField.keyboardType = .default
//            textField.autocorrectionType = .default
//            textField.placeholder = "Reason for declining this patient?"
//            textField.clearButtonMode = .whileEditing
//        }
//        
//        // Add action buttons and present the Alert
//        alert.addAction(submitAction)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)
//    }
//    
//    @IBAction func acceptPatientButtonTapped(_ sender: Any) {
//        
//        //show segue modally identifier: newPatientAppointment
//        self.performSegue(withIdentifier: "newPatientAppointment", sender: self)
//        
//        
//        // Instantiate a view controller from Storyboard and present it
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
//        self.present(vc, animated: false, completion: nil)
//    }
//
    
    
//    @IBAction func completedPatientButtonTapped(_ sender: Any) {
//        
//        let completed = 2
//        self.moveAppointmentToSection(SectionNumber: completed)
//        
//        // Instantiate a view controller from Storyboard and present it
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
//        self.present(vc, animated: false, completion: nil)
//        //completedPatientButton.backgroundColor = UIColor.celestialBlue()
//        
//    }
    
    //
    // #MARK: - UNWIND SEGUE
    //
    
    //https://www.andrewcbancroft.com/2015/12/18/working-with-unwind-segues-programmatically-in-swift/
    @IBAction func unwindToPatientDashboard(segue: UIStoryboardSegue) {}
    
    //
    //#MARK - segue
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "patientToReferral" {
            if let toViewController = segue.destination as? ReferralsVC {
                toViewController.seguePatientID = "will get 1"
                toViewController.seguePatientNotes = "will get 2"
                toViewController.seguePatientName = "will get 3"
                toViewController.seguePatientCPID = "will get 4"//appointmentID
                toViewController.seguePatientDate = "will get 5"
                toViewController.segueHourMin = "will get 6"
                toViewController.segueBookMinutes = "will get 7"
                toViewController.segueProviderName = "will get 8"
                toViewController.segueProviderID = "will get 9"
                toViewController.segueEncounterType = "will get 10"
                toViewController.segueEncounterPurpose = "will get 11"
                toViewController.segueLocationType = "will get 12"
                toViewController.segueBookPlace = "will get 13"
                toViewController.segueBookAddress = "will get 14"
                toViewController.seguePreAuth = "will get 15"
                toViewController.segueAttachDoc = "will get 16"
                toViewController.segueStatus = "will get 17"
                toViewController.segueIsUrgent = "N"
            }
        }
    }
    
    
}
