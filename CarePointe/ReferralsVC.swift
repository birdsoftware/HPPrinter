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
    
    // Views
    @IBOutlet weak var buttonView: UIView!
    
    
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var appointmentID: UILabel!
    
    //buttons
    @IBOutlet weak var homeHealthButton: UIButton!  //[] "Y" or anything else show checkBox
    @IBOutlet weak var changeDateTimeButton: RoundedButton!
    
    
    @IBOutlet weak var homeHealthLabel: UILabel!
    
    @IBOutlet weak var appointmentNotes: UITextView!//set not editable in storyboard
    @IBOutlet weak var appointmentDate: UILabel!
    @IBOutlet weak var lengthOfAppointmentLabel: UILabel!
    @IBOutlet weak var provider: UILabel!
    @IBOutlet weak var providerID: UILabel!
    
    @IBOutlet weak var encounterType: UILabel!//7. book_type
    @IBOutlet weak var encounter: UILabel!
    
    @IBOutlet weak var purposeOfRefferal: UITextField! //8. book_purpose
    @IBOutlet weak var placeOfReferral: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var priorAuthorizatin: UITextField!
    @IBOutlet weak var attachDocument: UILabel!
    
    @IBOutlet weak var mapButton: RoundedButton!
    
    
    //pickers
    @IBOutlet weak var encounterTypePicker: UIPickerView!
    @IBOutlet weak var placeOfReferralPicker: UIPickerView!
    @IBOutlet weak var attachDocPicker: UIPickerView!
    @IBOutlet weak var apptLengthPicker: UIPickerView!
    
    //segue Data from PTVTableViewController
    var seguePatientNotes: String!
    var seguePatientName: String!
    var seguePatientCPID: String!
    var seguePatientDate: String!
    var segueHourMin: String!
    var segueBookMinutes: String!
    var segueProviderName: String!
    var segueProviderID: String!
    var segueEncounterType: String!
    var segueEncounterPurpose: String!
    var segueLocationType: String!
    var segueBookPlace: String!
    var segueBookAddress: String!
    var seguePreAuth: String!
    var segueAttachDoc: String!
    var segueStatus: String!
    
    
    //class data
    let imgBox = UIImage(named:"box.png")
    let imgCheckBox = UIImage(named:"checkBox.png")
    var toggleState = 1
    
    var selectLocationType = ["Pharmacy","Office","Home","Urgent Care","Inpatient Hospital", "OutPatient Hospital", "Emergency Room Hospital", "Ambulatory Surgical Center", "SNF"]
    var selectEncounterType = ["Consult","Blood Work","BP Check","Ancillary Visit","Dietitian Visit", "DMV Physical", "Education Visit", "Established Patient", "F/up Hospital"]
    var selectAttachDocument = ["Intake PDF","Vitals Update","Blood Work","Doc 4"]
    
    var lenTimes = ["15 min", "30 min", "45 min", "60 min", "2 hours", "3 hours"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Picker Delegates
        encounterTypePicker.delegate = self
        encounterTypePicker.dataSource = self
        placeOfReferralPicker.delegate = self
        placeOfReferralPicker.delegate = self
        attachDocPicker.delegate = self
        attachDocPicker.dataSource = self
        apptLengthPicker.delegate = self
        apptLengthPicker.dataSource = self

        // UI Setup
        buttonView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        homeHealthButton.isHidden = true
        homeHealthLabel.isHidden = true
        
        displaySeguePTVTableData()
        
        //Conditional UI Setup
        // -- based on segueStatus //"Pending" or "Scheduled" or "Complete"
        if segueStatus == "Complete"{
            updateUIForComplete()
        }

        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    
    //
    // #MARK: - Supporting Functions
    //
    
    func updateUIForComplete(){ //segueStatus == "Complete"
        
        buttonView.isHidden = true
        encounterTypePicker.isHidden = true
        placeOfReferralPicker.isHidden = true
        attachDocPicker.isHidden = true
        apptLengthPicker.isHidden = true
        changeDateTimeButton.isEnabled = false
    }
    
    func showDeclineAlert(){

        // Show Alert, ask why, get leave a note text, show [Submit] [Cancel] buttons
        let alert = UIAlertController(title: "Decline Patient",
                                      message: "Submit decline patient for "+seguePatientName,
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // get patientID
            let patientID = self.returnSelectedPatientID()
            var userName:String = ""
            
            // get profile user name
            if self.isKeyPresentInUserDefaults(key: "profileName") {
                userName = UserDefaults.standard.string(forKey: "profileName")!
            }
            if self.isKeyPresentInUserDefaults(key: "profileLastName") {
                userName += " " + UserDefaults.standard.string(forKey: "profileLastName")!
            }
            
            // Get 1st TextField's text
            let declineMessage = "Patient \(patientID) declined by \(userName). " + alert.textFields![0].text! //print(textField)
            
            // 1 MOVE PATIENT FROM NEW TO COMPLETED
            let completed = 2 //0 new,1 accept,2 completed
            self.moveAppointmentToSection(SectionNumber: completed)
            
            // 2 UPDATE PATIENT FEED
            //      times   dates   messageCreator  message     patientID
            self.insertPatientFeed(messageCreator: userName, message: declineMessage, patientID: patientID, updatedFrom: "mobile", updatedType: "Update")
            
            
            // 3. Instantiate a view controller from Storyboard and present it
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
            self.present(vc, animated: false, completion: nil)
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // Add 1 textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Reason for declining this patient?"
            textField.clearButtonMode = .whileEditing
        }
        
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    //This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func displaySeguePTVTableData(){
    
        patientName.text = seguePatientName
        appointmentID.text = "Appointment ID: " + seguePatientCPID
        
        appointmentNotes.text = seguePatientNotes//"PC eval 4/25/2017"
        appointmentDate.text = "Appointment Date: " + convertDateStringToDate(longDate: seguePatientDate) + " " + segueHourMin
        lengthOfAppointmentLabel.text = "Length of Appointment: " + segueBookMinutes
        
        provider.text = "Assigned Provider: " + segueProviderName
        providerID.text = "Assigned Provider ID: " + segueProviderID
        
        //Encounter Type - see picker also
        if segueEncounterType != "" { encounter.text = segueEncounterType }
            
        if segueEncounterPurpose != "" { purposeOfRefferal.text = segueEncounterPurpose }
        
        //Place of Referral - see picker also
        if segueLocationType != "" { placeOfReferral.text = segueLocationType }
        
        address.text = segueBookAddress
        if segueBookAddress == "" { mapButton.isHidden = true }
        
        if seguePreAuth != "" { priorAuthorizatin.text = seguePreAuth }
        
        //Place of Referral - see picker also
        if segueAttachDoc != "" {
            segueAttachDoc = segueAttachDoc.replacingOccurrences(of: ",", with: " ")
            attachDocument.text = segueAttachDoc
        }
        
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
        showDeclineAlert()
    }
    
    @IBAction func discussButtonTapped(_ sender: Any) {     //DISCUSS
    }
    
    @IBAction func patientProfileButtonTapped(_ sender: Any) {
    }
    
    //change date time length Buttons
    @IBAction func changeDateTimeButtonTapped(_ sender: Any) {
        
        //var searchText = "2/14/17"
        
        DatePickerDialog().show("Appointment Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .dateAndTime) {
            (date) -> Void in
            if date != nil {
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = DateFormatter.Style.short // --NO TIME .short
                let strDate = dateFormat.string(for: date!)!
                
                let formatterTime = DateFormatter()
                formatterTime.timeStyle = .short
                let strTime =  formatterTime.string(from: date!)
                
                //----- UPDATE LABEL BY DATE SELECTED ---------
               self.appointmentDate.text = "Appointment Date: \(strDate) \(strTime)"
                
            }
        }
        //Save new date to user defaults
        //UserDefaults.standard.set(true, forKey: "didUpdateCalendarDate") //need check to display a date if no date selected
        
    }
    @IBAction func changeApptLengthButtonTapped(_ sender: Any) {
        
//        DatePickerDialog().show("Appointment Length", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
//            (date) -> Void in
//            if date != nil {
//                
//                //----- UPDATE LABEL BY DATE SELECTED ---------
//                self.lengthOfAppointmentLabel.text = "Length of Appointment: \(date!)"
//                
//            }
//        }
        
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
        
        if pickerView == encounterTypePicker {
            
            return selectEncounterType.count
            
        }
        if pickerView == placeOfReferralPicker{
            
            return selectLocationType.count
            
        }
        if pickerView == apptLengthPicker {
            
            return lenTimes.count
        }
        else {//if pickerView == attachDocPicker
            
            return selectAttachDocument.count
        }
    }
    // returns data to display in care team picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == encounterTypePicker {
            
            return selectEncounterType[row]
            
        }
        if pickerView == placeOfReferralPicker{
            
            return selectLocationType[row]
            
        }
        if pickerView == apptLengthPicker {
            
            return lenTimes[row]
        }
        else {//if pickerView == attachDocPicker
            
            return selectAttachDocument[row]
        }

    }
    // picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if pickerView == encounterTypePicker {//
            
            encounter.text = selectEncounterType[row]
            
        }
        if pickerView == placeOfReferralPicker{
            
            placeOfReferral.text = selectLocationType[row]
            
        }
        if pickerView == attachDocPicker{//attachDocPicker: UIPickerView!
            
            attachDocument.text = selectAttachDocument[row]
        }
        if pickerView == apptLengthPicker{
            
            lengthOfAppointmentLabel.text = "Length of Appointment: " + lenTimes[row]
        }
        
        
        //
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
