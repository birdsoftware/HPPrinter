//
//  PatientUpdateViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientUpdateViewController: UIViewController {

    @IBOutlet weak var patientNameTitle: UILabel!
    @IBOutlet weak var messageTextBox: UITextView!
    @IBOutlet weak var patientImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show patient Name in title
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        patientNameTitle.text = "Patient: " + patientName!
        
        //set update UI
        messageTextBox.layer.borderWidth = 1.0
        messageTextBox.layer.borderColor = UIColor(hex: 0xD7D7D7).cgColor// Iron
        messageTextBox.layer.cornerRadius = 5
        patientImage.layer.cornerRadius = patientImage.frame.size.width / 2
        patientImage.clipsToBounds = true
        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    // This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
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
            
            //if you perform segue it will perform after it finish animating.
            
            self.performSegue(withIdentifier: "unwindToPatientFeed", sender: self)
            
        })
    }

    
    
}
