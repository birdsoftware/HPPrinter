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
    
    //constraints
    @IBOutlet weak var bluePatientInfoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bluePatientInfoTop: NSLayoutConstraint!
    
    
    //labels
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var appointmentID: UILabel!
    @IBOutlet weak var referralLabel: UILabel!
    
    //buttons
    @IBOutlet weak var homeHealthButton: UIButton!  //[] "Y" or anything else show checkBox
    @IBOutlet weak var changeDateTimeButton: RoundedButton!
    @IBOutlet weak var completeButton: RoundedButton!
    @IBOutlet weak var callButton: RoundedButton!
    @IBOutlet weak var messageButton: RoundedButton!
    @IBOutlet weak var discussButton: RoundedButton!
    
    
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
    var seguePatientID: String!
    var seguePatientNotes: String!
    var seguePatientName: String!
    var seguePatientCPID: String!//appointmentID
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
    //"Pending" or "Scheduled" or "Complete" from ->"Complete","Rejected/Inactive","Cancelled"||"Scheduled","In Service"||"Pending","Opened"
    
    
    //class data
    var isDiscuss = true
    var referrals = Array<Dictionary<String,String>>()
    
    let imgBox = UIImage(named:"box.png")
    let imgCheckBox = UIImage(named:"checkBox.png")
    var toggleState = 1
    
    var selectLocationType = ["Pharmacy","Office","Home","Urgent Care","Inpatient Hospital", "OutPatient Hospital", "Emergency Room Hospital",
                              "Ambulatory Surgical Center", "SNF"]
    var selectEncounterType = [
        "Acne","Ancillary visit","Blood work","Blood check","BOTOX","BP check","CCM","Chemical peel","Child physical","Consult","Dermal filler","Dietitian visit",
        "DMV physical","Education visit","Established patient","Follow up","F/up hospital","F/up post op","F/up wellness visit","Female physical",
        "Forms","Goitre evaluation","Lab results","Lab visit","Male physical","Medical records","New patient","Nurse visit","Office visit",
        "Other procedure","Pap","PPD/Tb skin test","Pre op visit","Problems","Procedure","Same day apt","School physical","Test results",
        "Thyroid evaluation","Vaccination","Walk in","Weight check","Well baby visit","Wellness visit","Work physical","Wound check","Stress test",
        "Sports physical","Surgery consultation","TCM"
    ]
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
        completeButton.isHidden = true
        callButton.isHidden = true
        messageButton.isHidden = true
        
        displaySeguePTVTableData()
        
        //Conditional UI Setup
        // -- based on segueStatus //"Pending" or "Scheduled" or "Complete"
        if segueStatus == "Complete"{
            updateUIForComplete()
            referralLabel.text = "Completed Referral"
            bluePatientInfoTop.constant -= 50
        }
        if segueStatus == "Scheduled"{
            completeButton.isHidden = false
            updateUIForComplete()
            referralLabel.text = "Scheduled Referral"
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
    func segueToHomeView(){
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    func segueToConnectView(){
        let storyboard = UIStoryboard(name: "communication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "communicationVC") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    func segueToPTV(){
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    func updateStatusToComplete(){
        //1 find Refferal with this appointmentID (seguePatientCPID) and change status from Scheduled to Complete
        if isKeyPresentInUserDefaults(key: "RESTAllReferrals"){
            referrals = UserDefaults.standard.object(forKey: "RESTAllReferrals") as! Array<Dictionary<String, String>>
            var Iterator = 0
            for dict in referrals{
                //print("referral care plan id: \(dict["Care_Plan_ID"]!)")
                if dict["Care_Plan_ID"] == seguePatientCPID{
                    //print("Care_Plan_ID is \(seguePatientCPID) iterator is \(Iterator)")
                    referrals[Iterator].updateValue("Complete", forKey: "Status")
                    break
                }
                Iterator+=1
            }
        }
    }
    func updateStatusToScheduled(){
        if isKeyPresentInUserDefaults(key: "RESTAllReferrals"){
            referrals = UserDefaults.standard.object(forKey: "RESTAllReferrals") as! Array<Dictionary<String, String>>
            var Iterator = 0
            for dict in referrals{
                if dict["Care_Plan_ID"] == seguePatientCPID{
                    referrals[Iterator].updateValue("Scheduled", forKey: "Status")
                    break
                }
                Iterator+=1
            }
        }
    }
    
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
            //let patientID = self.returnSelectedPatientID()
            var userName:String = ""
            
            // get profile user name
            if self.isKeyPresentInUserDefaults(key: "profileName") { userName = UserDefaults.standard.string(forKey: "profileName")! }
            if self.isKeyPresentInUserDefaults(key: "profileLastName") { userName += " " + UserDefaults.standard.string(forKey: "profileLastName")! }
            
            // Get 1st TextField's text
            let declineMessage = "Patient \(self.seguePatientName!) declined by \(userName). " + alert.textFields![0].text! //print(textField)
            
            // 1 MOVE PATIENT FROM PENDING TO COMPLETED
            self.updateStatusToComplete()
            UserDefaults.standard.set(self.referrals, forKey: "RESTAllReferrals")
            UserDefaults.standard.synchronize()
            
            // 2 UPDATE PATIENT FEED
            //      times   dates   messageCreator  message     patientID
            self.insertPatientFeed(messageCreator: userName, message: declineMessage, patientID: self.seguePatientID, updatedFrom: "mobile", updatedType: "Update")
            
            
            // 3. Instantiate view controller from Storyboard and present it
            self.segueToPTV()
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
        segueToHomeView()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {        //BACK
        
        segueToPTV()
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {      //ACCEPT
        updateStatusToScheduled()
        
        UserDefaults.standard.set(referrals, forKey: "RESTAllReferrals")
        UserDefaults.standard.synchronize()
        
        segueToPTV()
    }
    
    @IBAction func declineButtonTapped(_ sender: Any) {     //DECLINE
        showDeclineAlert()
    }
    
    @IBAction func discussButtonTapped(_ sender: Any) {     //DISCUSS
        
        if isDiscuss {
            bluePatientInfoViewHeight.constant += 50
            callButton.isHidden = false
            messageButton.isHidden = false
            discussButton.backgroundColor = .white
            discussButton.setTitleColor(.bostonBlue(), for: .normal)
            discussButton.layer.borderWidth = 1
            discussButton.layer.borderColor = UIColor(hex: 0x3B8DBD).cgColor //boston blue
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        } else {
            bluePatientInfoViewHeight.constant -= 50
            callButton.isHidden = true
            messageButton.isHidden = true
            discussButton.backgroundColor = .bostonBlue()
            discussButton.setTitleColor(.white, for: .normal)
            discussButton.layer.borderWidth = 1
            //discussButton.layer.borderColor = UIColor.white.cgColor
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        isDiscuss = !isDiscuss
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        updateStatusToComplete()
        
        UserDefaults.standard.set(referrals, forKey: "RESTAllReferrals")
        UserDefaults.standard.synchronize()
        
        segueToPTV()
    }
    
    
    @IBAction func patientProfileButtonTapped(_ sender: Any) {
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        segueToConnectView()
    }
    @IBAction func messageButtonTapped(_ sender: Any) {
        segueToConnectView()
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
