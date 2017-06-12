//
//  PatientUpdateViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientUpdateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var patientNameTitle: UILabel!
    
    @IBOutlet weak var messageTextBox: UITextView!
    @IBOutlet weak var patientImage: UIImageView!
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var button: RoundedButton!
    
    //public class vars
    var type = [String]()
    
    var chosenType:String = "Routine"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patientImage.isHidden = true
        // Delegates
        typePicker.delegate = self
        typePicker.dataSource = self
        
        type = ["Routine", "CICA", "Urgent", "IDT"]
        
        // show patient Name in title
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        patientNameTitle.text = "Patient: " + patientName!
        
        //set update UI
        messageTextBox.layer.borderWidth = 1.0
        messageTextBox.layer.borderColor = UIColor(hex: 0xD7D7D7).cgColor// Iron
        messageTextBox.layer.cornerRadius = 5
        
        // Round userImage
        //patientImage.layer.cornerRadius = patientImage.frame.size.width / 2
        //patientImage.clipsToBounds = true
        
        
        //updateToSavedImage(Userimage: patientImage)
        
        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    // This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //supporting functions
    
    func appendNewMessageToDefaults(){
        
        var userName = ""
        //if value does not exists don't update placehold text, O.W. display locally saved text
        // get profile user name
        if isKeyPresentInUserDefaults(key: "profileName") {
            userName = UserDefaults.standard.string(forKey: "profileName")!
        }
        if isKeyPresentInUserDefaults(key: "profileLastName") {
            userName += " " + UserDefaults.standard.string(forKey: "profileLastName")!
        }
        
        
        self.insertPatientFeed(messageCreator: userName, message: messageTextBox.text, patientID: "", updatedFrom: "mobile", updatedType: chosenType)
        
    }
    
    
    // Button Actions
    
    @IBAction func goBackButtonTapped(_ sender: Any) {
        //1. palce "@IBAction func unwind...(segue: UIStoryboardSegue) {}" in view controller you want to unwind too
        //2. In storyboard connect this view () -> to [exit]
        //   In storyboard set unwind segue identifier: "unwindToPatientDB"
        //                     Action: "unwind..."
        //3. Trigger unwind segue programmatically (below)
        
        self.performSegue(withIdentifier: "unwindToPatientFeed", sender: self)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        //check internet
        
        
        
        //TOAST Update Sent
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

    
    //
    // #MARK: - Picker View
    //
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // returns the number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return type.count
    }
    
    // returns data to display in care team picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return type[row]
    }
    // picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        button.setTitle("Send " + type[row], for: .normal)
        chosenType = type[row]

    }

    
}
