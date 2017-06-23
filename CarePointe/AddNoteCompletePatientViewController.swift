//
//  AddNoteCompletePatientViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/16/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class AddNoteCompletePatientViewController: UIViewController {
    
    //labels
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var appointmentLabel: UILabel!
    @IBOutlet weak var patientIDLabel: UILabel!
    
    //view
    @IBOutlet weak var messageTextBox: UITextView!
    
    //button
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var blueBoxHeightConstraint: NSLayoutConstraint!
    
    var isInfo = true
    
    var patient: String!// = ""
    var patientID: String!// = ""
    var appointmentID: String!//referral ID is Care_Plan_ID
    var userName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        patientIDLabel.isHidden = true
        appointmentLabel.isHidden = true
        appointmentLabel.text = "Appointment ID: \(appointmentID!)"
        patientIDLabel.text = "Patient ID: \(patientID!)"
        patientName.text = "Patient: " + patient

        
        // get profile user name
        if isKeyPresentInUserDefaults(key: "profileName") {
            userName = UserDefaults.standard.string(forKey: "profileName")!
        }
        if isKeyPresentInUserDefaults(key: "profileLastName") {
            userName += " " + UserDefaults.standard.string(forKey: "profileLastName")!
        }
        
        // get patientID
        //patientID = self.returnSelectedPatientID()
        
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

    func updateStatusToComplete(){
        //1 find Refferal with this appointmentID (seguePatientCPID) and change status from Scheduled to Complete
        
        var referrals = Array<Dictionary<String, String>>()
        
        if isKeyPresentInUserDefaults(key: "RESTAllReferrals"){
            referrals = UserDefaults.standard.object(forKey: "RESTAllReferrals") as! Array<Dictionary<String, String>>
            var Iterator = 0
            for dict in referrals{
                //print("referral care plan id: \(dict["Care_Plan_ID"]!)")
                if dict["Care_Plan_ID"] == appointmentID{      //appointmentID
                    //print("Care_Plan_ID is \(seguePatientCPID) iterator is \(Iterator)")
                    referrals[Iterator].updateValue("Complete", forKey: "Status")
                    break
                }
                Iterator+=1
            }
        }
        
        UserDefaults.standard.set(referrals, forKey: "RESTAllReferrals")
        UserDefaults.standard.synchronize()
        
    }
    
    func dictUpdate() -> Dictionary<String, String>{
        //print("messageTextBox.text! .\(messageTextBox.text!).")
        let dict = (["patientUpdateText":"\(messageTextBox.text!)","update_type":"Routine","updated_from":"mobile app"])
        return dict
        
    }
    
    func sendUpdate(){
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            //let demographics = UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//saved from PatientListVC
            //let patientID = demographics[0][1]//"UniqueID"
            let userProfile = UserDefaults.standard.object(forKey: "userProfile") as? Array<Dictionary<String,String>> ?? []
            if userProfile.isEmpty == false
            {
                let user = userProfile[0]
                
                let User_ID = user["User_ID"]!
                
                let patientUpdateFlag = DispatchGroup()
                patientUpdateFlag.enter()
                
                POSTPatientUpdates().updatePatientUpdates(token: token, userID: User_ID, patientID: self.patientID, update: self.dictUpdate(), dispachInstance: patientUpdateFlag)
                
                patientUpdateFlag.notify(queue: DispatchQueue.main) {//cloud successfully updated
                    
                    //TOAST Update Sent
                    UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
                        
                        //if you perform segue here if will perform with animation
                        self.view.makeToast("Patient Complete", duration: 1.1, position: .center)
                    }, completion: { finished in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "NavControllerMainDB") as UIViewController //PTV
                        self.present(vc, animated: true, completion: nil)
                    })
                    
                }
            }
        }
    }


    //
    //#MARK - Button Actions
    //
    
    @IBAction func completPatientButtonTapped(_ sender: Any) {
        
        // 1 MOVE PATIENT FROM ACCEPTED TO COMPLETED
        self.updateStatusToComplete()
        
        
        // 2 UPDATE PATIENT FEED
        
        self.sendUpdate()
        
//        //                            times     dates   messageCreator  message     patientID
//        self.insertPatientFeed(messageCreator: userName, message: messageTextBox.text, patientID: patientID, updatedFrom: "mobile", updatedType: "Update")
//        
//        // ANIMATE "Patient Complete" TOAST then unwind segue back to MAIN dashboard
//        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
//            
//            self.view.makeToast("Patient Complete", duration: 1.1, position: .center)
//            
//        }, completion: { finished in
//            
//            
//                //unwind segue after animating - DID NOT UPDATE LIST VIEW
//                //1. palce "@IBAction func unwind...(segue: UIStoryboardSegue) {}" in view controller you want to unwind too
//                //2. In storyboard connect this view () -> to [exit]
//                //   In storyboard set unwind segue identifier: "unwindToMainDB"
//                //                     Action: "unwind..."
//                //3. Trigger unwind segue programmatically (below)
//                //self.performSegue(withIdentifier: "unwindToMainDB", sender: self)
//            
//            // Instantiate a view controller from Storyboard and present it
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "NavControllerMainDB") as UIViewController //PTV
//            self.present(vc, animated: true, completion: nil)
//            
//        })
        
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        
        if isInfo {
            patientIDLabel.isHidden = false
            appointmentLabel.isHidden = false
            blueBoxHeightConstraint.constant += 50
            //infoButton.backgroundColor = .white
            infoButton.setTitleColor(.black, for: .normal)
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        } else {
            patientIDLabel.isHidden = true
            appointmentLabel.isHidden = true
            blueBoxHeightConstraint.constant -= 50
            infoButton.setTitleColor(.white, for: .normal)
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        
        isInfo = !isInfo
    }
    
    
    
}


