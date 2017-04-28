//
//  ReferralsVC.swift
//  CarePointe
//
//  Created by Brian Bird on 4/24/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit
import MapKit

class ReferralsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //@IBOutlet weak var urgentButton: UIButton!      //[] "Y" or anything else show checkBox
    @IBOutlet weak var homeHealthButton: UIButton!  //[] "Y" or anything else show checkBox
    @IBOutlet weak var homeHealthLabel: UILabel!
    
    @IBOutlet weak var appointmentNotes: UITextView!//set not editable in storyboard
    @IBOutlet weak var appointmentDate: UILabel!
    @IBOutlet weak var lengthOfAppointment: RoundedButton!
    @IBOutlet weak var encounterType: UILabel!//7. book_type
    @IBOutlet weak var purposeOfRefferal: UITextField! //8. book_purpose
    @IBOutlet weak var placeOfRefferal: UILabel!
    @IBOutlet weak var priorAuthorizatin: UITextField!
    @IBOutlet weak var attachDocument: UILabel!
    
    //pickers
    @IBOutlet weak var encounterTypePicker: UIPickerView!
    @IBOutlet weak var placeOfReferralPicker: UIPickerView!
    @IBOutlet weak var attachDocPicker: UIPickerView!
    
    //lebels picker updates
    @IBOutlet weak var encountersLabel: UILabel!
    @IBOutlet weak var placeReferralLabel: UILabel!
    
    
    //class data
    let imgBox = UIImage(named:"box.png")
    let imgCheckBox = UIImage(named:"checkBox.png")
    var toggleState = 1
    
    var selectLocationType = ["Pharmacy","Office","Home","Urgent Care","Inpatient Hospital", "OutPatient Hospital", "Emergency Room Hospital", "Ambulatory Surgical Center", "SNF"]
    var selectEncounterType = ["Consult","Blood Work","BP Check","Ancillary Visit","Dietitian Visit", "DMV Physical", "Education Visit", "Established Patient", "F/up Hospital"]
    var selectAttachDocument = ["Intake PDF","Vitals Update","Blood Work","Doc 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        encounterTypePicker.delegate = self
        encounterTypePicker.dataSource = self

        homeHealthButton.isHidden = true
        homeHealthLabel.isHidden = true
        
        appointmentNotes.text = "PC eval 4/25/2017"
        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //
    // #MARK: - Buttons
    //
    
    @IBAction func homeButtonTapped(_ sender: Any) {        // HOME
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {        //BACK
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {      //ACCEPT
    }
    
    @IBAction func declineButtonTapped(_ sender: Any) {     //DECLINE
    }
    
    @IBAction func discussButtonTapped(_ sender: Any) {     //DISCUSS
    }
    
    @IBAction func patientProfileButtonTapped(_ sender: Any) {
    }
    @IBAction func mapDirectionsButtonTapped(_ sender: Any) {
        let latitude = 37.7
        let longitude = -122.7
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//            UIApplication.shared.openURL(NSURL(string:
//                "comgooglemaps://?saddr=&daddr=\(Float(latitude)),\(Float(longitude))&directionsmode=driving")! as URL)
            open(scheme: "comgooglemaps://?saddr=&daddr=\(Float(latitude)),\(Float(longitude))&directionsmode=driving")
            
        } else {
            NSLog("Can't use comgooglemaps://");
        }
        
    }
    
    
    //
    // #MARK: - Picker View
    //
    //encounterTypePicker
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // returns the number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return selectEncounterType.count
    }
    // returns data to display in care team picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectEncounterType[row]
    }
    // picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        encountersLabel.text = "Encounter Type: " + selectEncounterType[row]
        //availDay = selectEncounterType[row]
    }

    
    
    
    // supporting functions
    
    func open(scheme: String) {
        //http://useyourloaf.com/blog/openurl-deprecated-in-ios10/
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    
//    @IBAction func urgentButtonTapped(_ sender: Any) {
//        
//        if toggleState == 1 {
//            toggleState = 2
//            urgentButton.setImage(imgCheckBox,for: .normal)
//        } else {
//            toggleState = 1
//            urgentButton.setImage(imgBox,for: .normal)
//        }
//        
//    }
    

}
