//
//  PatientUpdateViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientUpdateViewController: UIViewController {

    //@IBOutlet weak var patientNameTitle: UILabel!
    @IBOutlet weak var patientNameTitle: UILabel!
    
    @IBOutlet weak var messageTextBox: UITextView!
    @IBOutlet weak var patientImage: UIImageView!
    
    var feedData = [[String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show patient Name in title
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        patientNameTitle.text = "Patient: " + patientName!
        
        //set update UI
        messageTextBox.layer.borderWidth = 1.0
        messageTextBox.layer.borderColor = UIColor(hex: 0xD7D7D7).cgColor// Iron
        messageTextBox.layer.cornerRadius = 5
        // Round userImage
        patientImage.layer.cornerRadius = patientImage.frame.size.width / 2
        patientImage.clipsToBounds = true
        updateToSavedImage(Userimage: patientImage)
        
        
        feedData = UserDefaults.standard.object(forKey: "feedData") as! [[String]] //?? [[String]]()
//        times = feedData.getColumn(column: 0)
//        dates = feedData.getColumn(column: 1)
//        messageCreator = feedData.getColumn(column: 2)
//        message = feedData.getColumn(column: 3)
        
        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    // This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
//    func isKeyPresentInUserDefaults(key: String) -> Bool {
//        return UserDefaults.standard.object(forKey: key) != nil
//    }
    
    func appendNewMessageToDefaults(){
        //let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
//        let date = Date()
//        let formatter = DateFormatter()
//        let formatterTime = DateFormatter()
//        formatter.dateStyle = .short // = "M/dd/yy"
//        formatterTime.timeStyle = .short
//        let currentTime = formatterTime.string(from: date)
//        let todaysDate = formatter.string(from: date) //"2/14/2017"
        
        var userName = ""
        //if value does not exists don't update placehold text, O.W. display locally saved text
        // get profile user name
        if isKeyPresentInUserDefaults(key: "profileName") {
            userName = UserDefaults.standard.string(forKey: "profileName")!
        }
        if isKeyPresentInUserDefaults(key: "profileLastName") {
            userName += " " + UserDefaults.standard.string(forKey: "profileLastName")!
        }
        
        //let messageCreatedBy = userName
        
        //let newUpdateMessage = self.messageTextBox.text
        
        self.insertPatientFeed(messageCreator: userName, message: messageTextBox.text, patientID: "")
        
//        print("From: " + messageCreatedBy)
//        print("Date: " + todaysDate)
//        print("Time: " + currentTime)
//        print("Update: " + newUpdateMessage!)
//        
//        let newUpdate = [currentTime,todaysDate,messageCreatedBy,newUpdateMessage!]
//        
//        // APPEND
//        
//        //feedData.append(newUpdate)
//        
//        //INSERT AT BEGINING
//        
//        feedData.insert(newUpdate, at: 0)
//        
//        UserDefaults.standard.set(feedData, forKey: "feedData")
//        UserDefaults.standard.synchronize()
    }
    
    @IBAction func goBackButtonTapped(_ sender: Any) {
        //1. palce "@IBAction func unwind...(segue: UIStoryboardSegue) {}" in view controller you want to unwind too
        //2. In storyboard connect this view () -> to [exit]
        //   In storyboard set unwind segue identifier: "unwindToPatientDB"
        //                     Action: "unwind..."
        //3. Trigger unwind segue programmatically (below)
        
        self.performSegue(withIdentifier: "unwindToPatientFeed", sender: self)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
            
            //if you perform segue here if will perform with animation
            self.view.makeToast("Update Sent", duration: 1.1, position: .center)
        }, completion: { finished in
            
            //Do this... after it finished animating.
            
            self.appendNewMessageToDefaults()
            
            self.performSegue(withIdentifier: "unwindToPatientFeed", sender: self)
            
            // reload table
            
        })
    }

    
    
}
