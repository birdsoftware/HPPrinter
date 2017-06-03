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
    @IBOutlet weak var backButtonImage: UIImageView!
    
    
    //Segue from PatientTabBarController from Referrals
    var storyBoardName: String!
    var referralsData = [String: String]()
    
    var patientName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get directly https://makeapppie.com/2015/02/04/swift-swift-tutorials-passing-data-in-tab-bar-controllers/
        
        let tbvc = self.tabBarController as! PatientTabBarController
        storyBoardName = tbvc.segueStoryBoardName
        referralsData["PatientID"] =    tbvc.tabBarSeguePatientID//"1848"
        referralsData["PatientNotes"] = tbvc.tabBarSeguePatientNotes
        referralsData["PatientName"] =  tbvc.tabBarSeguePatientName
        referralsData["PatientCPID"] =  tbvc.tabBarSeguePatientCPID//"2637"
        referralsData["PatientDate"] =  tbvc.tabBarSeguePatientDate//"4/1/17"
        referralsData["HourMin"] =      tbvc.tabBarSegueHourMin//":30"
        referralsData["BookMinutes"] =  tbvc.tabBarSegueBookMinutes//"60"
        referralsData["ProviderName"] = tbvc.tabBarSegueProviderName//"Admin Admin"
        referralsData["ProviderID"] =   tbvc.tabBarSegueProviderID//"148"
        referralsData["EncounterType"] = tbvc.tabBarSegueEncounterType//"TCM"
        referralsData["EncounterPurpose"] = tbvc.tabBarSegueEncounterPurpose
        referralsData["LocationType"] = tbvc.tabBarSegueLocationType
        referralsData["BookPlace"] = tbvc.tabBarSegueBookPlace
        referralsData["BookAddress"] = tbvc.tabBarSegueBookAddress
        referralsData["PreAuth"] = tbvc.tabBarSeguePreAuth
        referralsData["AttachDoc"] = tbvc.tabBarSegueAttachDoc
        referralsData["SegueStatus"] = tbvc.tabBarSegueStatus//"Pending"
        referralsData["IsUrgent"] = tbvc.tabBarSegueIsUrgent//"N"
        
        backButton.layer.cornerRadius = 5

        containerView1.isHidden = false
        containerView2.isHidden = true
        containerView3.isHidden = true
        containerView4.isHidden = true
        
        // store specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        patientName = UserDefaults.standard.string(forKey: "patientName")!
        
        // Setup segment control font and font size
        let attr = NSDictionary(object: UIFont(name: "Futura", size: 15.0)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if storyBoardName != nil {
            if storyBoardName! == "Refferal" {
                backButtonImage.image = UIImage(named: "calendar2.png")
            }
        }
    }

    
    
    //
    //#MARK - Supporting functions
    //

    //func updatePatientView(status: String){
    //
    //}
    
    
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
                toViewController.seguePatientID = referralsData["PatientID"]
                toViewController.seguePatientNotes = referralsData["PatientNotes"]
                toViewController.seguePatientName = referralsData["PatientName"]
                toViewController.seguePatientCPID = referralsData["PatientCPID"]//appointmentID
                toViewController.seguePatientDate = referralsData["PatientDate"]
                toViewController.segueHourMin = referralsData["HourMin"]
                toViewController.segueBookMinutes = referralsData["BookMinutes"]
                toViewController.segueProviderName = referralsData["ProviderName"]
                toViewController.segueProviderID = referralsData["ProviderID"]
                toViewController.segueEncounterType = referralsData["EncounterType"]
                toViewController.segueEncounterPurpose = referralsData["EncounterPurpose"]
                toViewController.segueLocationType = referralsData["LocationType"]
                toViewController.segueBookPlace = referralsData["BookPlace"]
                toViewController.segueBookAddress = referralsData["BookAddress"]
                toViewController.seguePreAuth = referralsData["PreAuth"]
                toViewController.segueAttachDoc = referralsData["AttachDoc"]
                toViewController.segueStatus = referralsData["SegueStatus"]
                toViewController.segueIsUrgent = referralsData["IsUrgent"]
            }
        }
    }
    
    
}
