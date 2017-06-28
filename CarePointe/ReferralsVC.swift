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
    @IBOutlet weak var buttonViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var callButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageButtonTopConstraint: NSLayoutConstraint!
        //picker constraints
    @IBOutlet weak var changeApptLenHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var changeApptLenTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var encounterTypeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var encounterTypeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var referralPlaceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var referralPlaceTopConstraint: NSLayoutConstraint!
    
    //title labels
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
    @IBOutlet weak var patientProfileButton: RoundedButton!
    @IBOutlet weak var changeAppointmentLengthButton: RoundedButton!
    @IBOutlet weak var encounterTypeButton: RoundedButton!
    @IBOutlet weak var referralPlaceButton: RoundedButton!
    
    //labels
    @IBOutlet weak var homeHealthLabel: UILabel!
    @IBOutlet weak var appointmentNotes: UITextView!//set not editable in storyboard
    @IBOutlet weak var appointmentDate: UILabel!
    @IBOutlet weak var lengthOfAppointmentLabel: UILabel!
    @IBOutlet weak var provider: UILabel!
    @IBOutlet weak var providerID: UILabel!
    
    //Complet? hide image
    @IBOutlet weak var calendarImage: UIImageView!
    
    //Complete labels
    @IBOutlet weak var changeReferralPurpose: UILabel!
    @IBOutlet weak var changePriorAuth: UILabel!
    @IBOutlet weak var appointmentNotesLabel: UILabel!
    
    //complete constraints
    @IBOutlet weak var appointmentNotesHeight: NSLayoutConstraint!
    @IBOutlet weak var apptDateButtonBottumCon: NSLayoutConstraint!
    @IBOutlet weak var encounterTypeTopC: NSLayoutConstraint!
    @IBOutlet weak var changeReferralPurposeTopCon: NSLayoutConstraint!
    @IBOutlet weak var placeOfReferralTopCon: NSLayoutConstraint!
    @IBOutlet weak var streetAdressLabelTopCon: NSLayoutConstraint!
    @IBOutlet weak var referralDetailView: NSLayoutConstraint!
    
    
    //complete Views
    @IBOutlet weak var grayBar2: UIView!
    @IBOutlet weak var grayBar3: UIView!
    @IBOutlet weak var grayBar4: UIView!
    @IBOutlet weak var grayBar5: UIView!
    @IBOutlet weak var grayBar6: UIView!
    @IBOutlet weak var grayBar7: UIView!
    @IBOutlet weak var grayBar8: UIView!
    @IBOutlet weak var grayBar9: UIView!
    
    
    //@IBOutlet weak var encounterType: UILabel!//7. book_type
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
        //segueStatus: 1."Pending" or 2."Scheduled" or 3."Complete"
        //RAW API: "Complete","Rejected/Inactive","Cancelled"||"Scheduled","In Service"||"Pending","Opened"
    var segueStatus: String!
    var segueIsUrgent: String!
    var token = ""
    
    //
    var dateUpToDate: String!
    var timeUpToDate: String!
    
    //map input
    var patientAddress = ""
    
    //class data
    var isEncounterOpen = true
    var isReferralPlaceOpen = true
    var isApptLen = true
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
    
    //Confirm information before saving alert
    var appointmentDateTime = String()
    var appointmentLength = String()
    var assignedProvider = String()
    var assignedProviderID = String()
    var encounterTypeVar = String()
    var referralPurpose = String()
    var placeOfReferralVar = String()
    var priorAuthorization = String()
    var attachDocumentVar = String()
    
    //ref send to API
    var referralSaveToAPI = Dictionary<String,String>()
    
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get profile user name
        if isKeyPresentInUserDefaults(key: "profileName") {
            userName = UserDefaults.standard.string(forKey: "profileName")!
        }
        
        //see what you got from PTV
        print("segueIsUrgent \(segueIsUrgent), seguePatientNotes \(seguePatientNotes), seguePatientName \(seguePatientName), seguePatientCPID \(seguePatientCPID), seguePatientDate \(seguePatientDate), segueHourMin \(segueHourMin), segueBookMinutes \(segueBookMinutes), segueProviderName \(segueProviderName), segueProviderID \(segueProviderID), seguePatientID \(seguePatientID),")
   
        
        dateUpToDate = seguePatientDate
        timeUpToDate = segueHourMin
        
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
        
        if segueIsUrgent != "Y" {
            homeHealthButton.isHidden = true
            homeHealthLabel.isHidden = true
        }
        completeButton.isHidden = true
        callButton.isHidden = true
        messageButton.isHidden = true
        
        
        //display info from PTVTableViewController.swift
        displaySeguePTVTableData()
        
        
        //Conditional UI Setup
        if segueStatus == "Pending"{
            discussButton.setTitle("Discuss \u{21E3}", for: .normal)//down
            changeAppointmentLengthButton.setTitle("Change Appointment Length \u{21E3}", for: .normal)//down
            encounterTypeButton.setTitle("Change Encounter Type \u{21E3}", for: .normal)//down
            referralPlaceButton.setTitle("Change Referral Place \u{21E3}", for: .normal)//down

            //picker constraints
            changeApptLenHeightConstraint.constant = 40
            encounterTypeHeightConstraint.constant = 40
            referralPlaceHeightConstraint.constant = 40
        }
        if segueStatus == "Complete"{
            //buttonViewTopConstraint.constant -= 50
            //bluePatientInfoTop.constant -= 50
            //callButtonTopConstraint.constant -= 50
            //messageButtonTopConstraint.constant -= 50
            updateUIForComplete()
            referralLabel.text = "Completed Referral"
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
        //constraints to change
        if appointmentNotes.text.isEmpty == true {
            appointmentNotesHeight.constant = 0
            appointmentNotesLabel.text = "No appointment notes given."
        }
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
    func updateReferralsAPI(forPatientFeed: String) {
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            let isConnectSuccess = UserDefaults.standard.bool(forKey: "APIGETTokenSuccess")
            if isConnectSuccess == false {
                //failed alert
                print("referral save/update api failed")
                ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                self.simpleAlert(title: "Referral connection failure", message: "Try again later and check your internet connection.", buttonTitle: "OK")
            }

            let updateReferral = DispatchGroup()
            updateReferral.enter()
            self.token = UserDefaults.standard.string(forKey: "token")!
            self.updateAnyChangesToTempMemory()

            //show activity indicator
            ViewControllerUtils().showActivityIndicator(uiView: self.view)
            //timer close after 11 seconds ActivityIndicator
            
            PUTReferrals().putReferralNow(token: self.token, carePlanID: self.seguePatientCPID, referral: self.referralSaveToAPI, dispachInstance: updateReferral)
            
            updateReferral.notify(queue: DispatchQueue.main) {
                //hide
                print("referral save/update api finished")
                ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                
                let isSaveSuccess = UserDefaults.standard.bool(forKey: "APIPUTReferralsSuccess")
                if isSaveSuccess == true{
                    
                    //IF SUCCESS SAVE ANY UPDATES/CHANGES LOCALLY
                    UserDefaults.standard.set(self.referrals, forKey: "RESTAllReferrals")
                    UserDefaults.standard.synchronize()
                    
                    // <<<<<<<<<<<<<< UPDATE PATIENT FEED here - forPatientFeed >>>>>>>>>>>>>>>>
                    let patientUpdateFlag = DispatchGroup(); patientUpdateFlag.enter();
                    
                    let userProfile = UserDefaults.standard.object(forKey: "userProfile") as? Array<Dictionary<String,String>> ?? []
                    if userProfile.isEmpty == false
                    {
                        let user = userProfile[0]
                        let User_ID = user["User_ID"]!
                        
                        let dict = (["patientUpdateText":"\(forPatientFeed)","update_type":"Routine","updated_from":"mobile app"])
                    
                        POSTPatientUpdates().updatePatientUpdates(token: self.token, userID: User_ID, patientID: self.seguePatientID, update: dict, dispachInstance: patientUpdateFlag)
                        
                    }// <<<<<<<<<<<<<<            END OF PATIENT FEED           >>>>>>>>>>>>>>>>
                    
                    self.segueToPTV()
                }
                if isSaveSuccess == false {
                    //failed alert
                    self.simpleAlert(title: "Failed to save changes online", message: "Try again later and check your internet connection.", buttonTitle: "OK")
                }
            }
        }
    }
    func updateStatusToComplete(){
        
        //UPDATE LOCAL
        //1 find Refferal with this appointmentID (seguePatientCPID) and change status from Scheduled to Complete
        if isKeyPresentInUserDefaults(key: "RESTAllReferrals"){
            referrals = UserDefaults.standard.object(forKey: "RESTAllReferrals") as! Array<Dictionary<String, String>>
            var Iterator = 0
            for dict in referrals{
                //print("referral care plan id: \(dict["Care_Plan_ID"]!)")
                if dict["Care_Plan_ID"] == seguePatientCPID{
                    //print("Care_Plan_ID is \(seguePatientCPID) iterator is \(Iterator)")
                    referrals[Iterator].updateValue("Complete", forKey: "Status")
                    
                    self.referralSaveToAPI = referrals[Iterator]
                    break
                }
                Iterator+=1
            }
        }
    }
    func updateStatusToScheduled(){//& save any changes locally
        if isKeyPresentInUserDefaults(key: "RESTAllReferrals"){
            referrals = UserDefaults.standard.object(forKey: "RESTAllReferrals") as! Array<Dictionary<String, String>>
            var Iterator = 0
            for dict in referrals{
                if dict["Care_Plan_ID"] == seguePatientCPID{
                    referrals[Iterator].updateValue("Scheduled", forKey: "Status")
                    
                    //-SAVE ANY CHANGES LOCALLY
                    let dateLong = convertDateToLongStringDate(dateString: appointmentDateTime)
                    
                    referrals[Iterator].updateValue(dateLong, forKey: "StartDate")//"2017-04-02T04:00:00.000Z" appointmentDateTime
                    referrals[Iterator].updateValue("30", forKey: "date_hhmm")//":30" appointmentDateTime
                    
                    let endIndex = appointmentLength.index(appointmentLength.endIndex, offsetBy: -4)//Remove " min" or "ours"
                    var truncated = appointmentLength.substring(to: endIndex)
                    if truncated.contains("h"){
                        let endIndex = truncated.index(truncated.endIndex, offsetBy: -2)//Remove " h"
                        truncated = truncated.substring(to: endIndex)
                    }
                    
                    referrals[Iterator].updateValue(truncated, forKey: "book_minutes")//appt len "60" appointmentLength
                    referrals[Iterator].updateValue(encounterTypeVar, forKey: "book_type")//book_type: "TCM",encounterTypeVar
                    referrals[Iterator].updateValue(placeOfReferralVar, forKey: "location_type")//book_place: "Home",placeOfReferralVar
                    referrals[Iterator].updateValue(priorAuthorization, forKey: "pre_authorization")//priorAuthorization
                    //-
                    //print("appointmentLength \(appointmentLength) encounterTypeVar \(encounterTypeVar) placeOfReferralVar \(placeOfReferralVar) priorAuthorization \(priorAuthorization)")
                    self.referralSaveToAPI = ["StartDate":dateLong,
                                              "date_hhmm":segueHourMin,
                                              "book_minutes":truncated,
                                              "Status":"Scheduled",
                                              "book_type":encounterTypeVar,
                                              "book_purpose":referralPurpose,
                                              "book_place":dict["book_place"]!,
                                              "pre_authorization":self.priorAuthorization,
                                              "Attachment_doc":dict["Attachment_doc"]!,
                                              "location_type":self.placeOfReferralVar  ]
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
        changeDateTimeButton.isHidden = true
        calendarImage.isHidden = true
        changeAppointmentLengthButton.isHidden = true
        encounterTypeButton.isHidden = true
        referralPlaceButton.isHidden = true
        
        //labels to change 
        //changeAppointmentLength.text = "Appointment Length:"
        changeReferralPurpose.text = "Referral Purpose:"
        changePriorAuth.text = "Prior-Authorization:"
        
        //constraints to change
        if appointmentNotes.text.isEmpty == true {
            appointmentNotesHeight.constant = 0
            appointmentNotesLabel.text = "No appointment notes given."
        }
        apptDateButtonBottumCon.constant = -50
        encounterTypeTopC.constant = -200
        changeReferralPurposeTopCon.constant = -125
        placeOfReferralTopCon.constant = 60
        streetAdressLabelTopCon.constant = -130
        referralDetailView.constant = 1000
        
        //views to hide
        grayBar2.isHidden = true
        grayBar3.isHidden = true
        grayBar4.isHidden = true
        grayBar5.isHidden = true
        grayBar6.isHidden = true
        grayBar7.isHidden = true
        grayBar8.isHidden = true
        grayBar9.isHidden = true
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
        lengthOfAppointmentLabel.text = segueBookMinutes// + " min"
        
        provider.text = "Assigned Provider: " + segueProviderName
        providerID.text = "Assigned Provider ID: " + segueProviderID
        
        //Encounter Type - see picker also
        if segueEncounterType != "" { encounter.text = segueEncounterType }
        
        if segueEncounterPurpose != "" { purposeOfRefferal.text = segueEncounterPurpose }
        
        //Place of Referral - see picker also
        if segueLocationType != "" { placeOfReferral.text = segueLocationType }
        
        
        
        address.text = segueBookAddress
        if segueBookAddress == "" { mapButton.isHidden = true } else {
            
            let searchableAddress = returnNotEmptyAddressString()
            
            address.text = "Address:\n\(searchableAddress)"//, \(city), \(state) \(zip)"
            patientAddress = "\(searchableAddress)"//, \(city), \(state) \(zip)"
        }
        
        /*if seguePreAuth != "" { */priorAuthorizatin.text = seguePreAuth// }
        
        //Place of Referral - see picker also
        if segueAttachDoc != "" {
            segueAttachDoc = segueAttachDoc.replacingOccurrences(of: ",", with: " ")
            attachDocument.text = segueAttachDoc
        }
    }
    
    func returnNotEmptyAddressString() -> String {
        /* INPUT: "Address -1 main street;State -NY;City -Bedminster;Zip -07921;Phone -8886337821;"
         * ["Address -1 main street",
         *  "State -NY",
         *  "City -Bedminster",
         *  "Zip -07921",
         *  "Phone -8886337821",
         *  ""]
         * For each element in address must contain a "-" and doesnot contain "Phone"
         * OUTPUT: "1 main street, NY, Bedminster, 07921"
         */
        
        if segueBookAddress.contains(";") {

            let bookAddressArray = splitStringToArray(StringIn: segueBookAddress, deliminator: ";")
            
            var addr = ""
            
            for element in bookAddressArray {
                if element.contains("-") {
                    if element.range(of: "Phone") == nil {//does not exist
                        let index = element.characters.index(of: "-")
                        var dashStr = element.substring(from: index!) + ", "
                        dashStr.remove(at: dashStr.startIndex)
                        addr += dashStr
                    }
                }
            }
            
            let endIndex = addr.index(addr.endIndex, offsetBy: -2)
            let truncated = addr.substring(to: endIndex)
            return truncated
            
        } else {
            
            return segueBookAddress
        }
    }
    
    //
    // #MARK: - Decline / Accept / Complete Alerts
    //
    func showDeclineAlert(){

        // Show Alert, ask why, get leave a note text, show [Submit] [Cancel] buttons
        let alert = UIAlertController(title: "Decline Patient",
                                      message: "Submit decline patient for "+seguePatientName,
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            
            // Get 1st TextField's text
            let declineMessage = "Patient \(self.seguePatientName!) declined by \(self.userName). " + alert.textFields![0].text! //print(textField)
            
            // 1 MOVE PATIENT FROM PENDING TO COMPLETED
            
            self.updateStatusToComplete()
            
            self.updateReferralsAPI(forPatientFeed: declineMessage)
            
//            UserDefaults.standard.set(self.referrals, forKey: "RESTAllReferrals")
//            UserDefaults.standard.synchronize()
////
//            // 2 UPDATE PATIENT FEED
//            //      times   dates   messageCreator  message     patientID
//            self.insertPatientFeed(messageCreator: self.userName, message: declineMessage, patientID: self.seguePatientID, updatedFrom: "mobile", updatedType: "Update")
//            
//            
//            // 3. Instantiate view controller from Storyboard and present it
//            self.segueToPTV()
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
    func updateAnyChangesToTempMemory(){
        appointmentDateTime = appointmentDate.text!
        appointmentLength = lengthOfAppointmentLabel.text! //"15 min"
        assignedProvider = provider.text! //"Admin"
        assignedProviderID = providerID.text! //"148"
        encounterTypeVar = encounter.text!//"TCM"
        referralPurpose = purposeOfRefferal.text!//"purpose"
        placeOfReferralVar = placeOfReferral.text!//"pharmacy"
        priorAuthorization = priorAuthorizatin.text!//"prior-auth"
        //attachDocumentVar = attachDocument.text!//"did not change"
    }

    func showAcceptAlert() {
        
        updateAnyChangesToTempMemory()
        
        let changeMessage = "\n\u{2022} 1) \(appointmentDateTime) \n" +
                            "\n\u{2022} 2) Appointment length: \(appointmentLength) \n" +
                            "\n\u{2022} 3) Encounter Type: \(encounterTypeVar) \n" +
                            "\n\u{2022} 4) Referral Purpose: \(referralPurpose) \n" +
                            "\n\u{2022} 5) Place of Referral: \(placeOfReferralVar) \n" +
                            "\n\u{2022} 6) Prior Authorization: \(priorAuthorization) \n"// +
                            //"\n\u{2022} 7) Attach Document: \(attachDocumentVar) \n"
        
        let myAlert = UIAlertController(title: "Confirm information before saving. Cancel to make changes.", message: changeMessage, preferredStyle: .alert)
        
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            // Get 1st TextField's text
            let acceptMessage = "Patient \(self.seguePatientName!) accepted by \(self.userName). " + myAlert.textFields![0].text! //print(textField)
            
            // 1 MOVE PATIENT FROM PENDING TO ACCEPTED
            self.updateStatusToScheduled()//self.saveTextLocally()
            
            self.updateReferralsAPI(forPatientFeed: acceptMessage)
            
        }))
        
        // Add 1 textField and customize it
        myAlert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Add a note here before saving"
            textField.clearButtonMode = .whileEditing
        }
        
        myAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in })
        
        present(myAlert, animated: true){}
    }
    
    func showCompleteAlert() {
    
        // Show Alert, ask why, get leave a note text, show [Submit] [Cancel] buttons
        let alert = UIAlertController(title: "Complete Patient",
                                      message: "Submit complete for "+seguePatientName,
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            
            // Get 1st TextField's text
            let completeMessage = "Patient \(self.seguePatientName!) completed by \(self.userName). " + alert.textFields![0].text! //print(textField)
            
            // 1 MOVE PATIENT FROM SCHEDULED TO COMPLETED
            self.updateStatusToComplete()
            
            self.updateReferralsAPI(forPatientFeed: completeMessage)
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // Add 1 textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Add completion note here."
            textField.clearButtonMode = .whileEditing
        }
        
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
        
        showAcceptAlert()
    }
    
    @IBAction func declineButtonTapped(_ sender: Any) {     //DECLINE
        showDeclineAlert()
    }
    @IBAction func changeAppointmentLengthButtonTapped(_ sender: Any) {
        
        togglePickerButton(isOpen: &isApptLen, button: changeAppointmentLengthButton, buttonTitle: "Change Appointment Length", topPickerConstraint: changeApptLenTopConstraint, hightPickerConstraint: changeApptLenHeightConstraint)
    }
    @IBAction func encounterTypeButtonTapped(_ sender: Any) {
        togglePickerButton(isOpen: &isEncounterOpen, button: encounterTypeButton, buttonTitle: "Change Encounter Type", topPickerConstraint: encounterTypeTopConstraint, hightPickerConstraint: encounterTypeHeightConstraint)
    }
    @IBAction func referralPlaceButtonTapped(_ sender: Any) {
        togglePickerButton(isOpen: &isReferralPlaceOpen, button: referralPlaceButton, buttonTitle: "Change Referral Place", topPickerConstraint: referralPlaceTopConstraint, hightPickerConstraint: referralPlaceHeightConstraint)
    }
    
    func togglePickerButton(isOpen: inout Bool, button: RoundedButton, buttonTitle: String, topPickerConstraint: NSLayoutConstraint, hightPickerConstraint: NSLayoutConstraint){
        if isOpen {
            button.setTitle(buttonTitle+" \u{21E1}", for: .normal)//up
            hightPickerConstraint.constant += 120
            topPickerConstraint.constant += 50
        } else {
            button.setTitle(buttonTitle+" \u{21E3}", for: .normal)//down
            hightPickerConstraint.constant -= 120
            topPickerConstraint.constant -= 50
        }
        isOpen = !isOpen
    }
    
    @IBAction func discussButtonTapped(_ sender: Any) {     //DISCUSS
        
        if isDiscuss {
            discussButton.setTitle("Discuss \u{21E1}", for: .normal)//up
        } else {
            discussButton.setTitle("Discuss \u{21E3}", for: .normal)//down
        }
        
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
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        isDiscuss = !isDiscuss
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        showCompleteAlert()
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
                
                //----- UPDATE UI LABEL BY DATE SELECTED ---------
               self.appointmentDate.text = "Appointment Date: \(strDate) \(strTime)"
                self.dateUpToDate = strDate
                self.timeUpToDate = strTime
            }
        }
        //Save new date to user defaults
        //UserDefaults.standard.set(true, forKey: "didUpdateCalendarDate") //need check to display a date if no date selected
    }
    
    @IBAction func mapDirectionsButtonTapped(_ sender: Any) {
        
        let callMapHere = ReferralsMap()
        callMapHere.showMap(destAddress: patientAddress, destName: "\(seguePatientName!) Address")
        
    }
    
    // supports above?
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
            
            lengthOfAppointmentLabel.text = lenTimes[row]//+ " min"
        }
        
    }

    
    //
    //#MARK: - segue?
    //
    
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        
        var arrayPatient:Array<Dictionary<String,String>> = []
        if isKeyPresentInUserDefaults(key: "RESTPatients"){
            arrayPatient = UserDefaults.standard.value(forKey: "RESTPatients") as! Array<Dictionary<String, String>>
        }
        
        
        var demographics = String()
        let key = "Patient_ID"
        let value = seguePatientID
        
        for dict in arrayPatient {
            if dict[key] == value {
                demographics = dict["Patient_ID"]!
            }
        }
        
        if demographics.isEmpty == true {
            patientProfileButton.setTitle("Not Available", for: .normal)
            patientProfileButton.setTitleColor(.red, for: .normal)
            patientProfileButton.layer.borderColor = UIColor.red.cgColor //boston blue
            return false
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //http://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
        // " 1. click cell drag to view 2. select the “show” segue in the “Selection Segue” section. "
        
        if segue.identifier == "patientPortal"{

            let patientName = seguePatientName//Data["patientName"]
            //let appointmentID = appID[sectionOfSelectedRow][selectedRow] as String
            let patientStatus = segueStatus//"Inactive"//Data["pstatus"]
            let patientImage = "" //appPatImage[sectionOfSelectedRow][selectedRow]
            
            // Store data locally change to mySQL? server later
            let defaults = UserDefaults.standard
            defaults.set(patientName, forKey: "patientName")
            defaults.set(patientImage, forKey: "patientPic")
            defaults.set(patientStatus, forKey: "patientStatus") //need this to hide the accept and decline buttons in completed view
            
            var arrayPatient:Array<Dictionary<String,String>> = []
            if isKeyPresentInUserDefaults(key: "RESTPatients"){
                arrayPatient = UserDefaults.standard.value(forKey: "RESTPatients") as! Array<Dictionary<String, String>>
            }
            
            var demographics=[[String]]()
            let key = "Patient_ID"
            let value = seguePatientID
            for dict in arrayPatient {
                if dict[key] == value {

                    demographics = [
                        ["UniqueID", dict["Patient_ID"]! ],
                        ["Gender", dict["Gender"]! ],
                        ["Ethnicity", dict["Ethnicity"]! ],
                        ["SSN#", dict["SSN"]! ],
                        ["DOB", convertDateStringToDate(longDate: dict["DOB"]!)],//Data["DOB"]! ],
                        ["Primary Language", dict["PrimaryLanguage"]! ],
                        ["Email", dict["EmailID"]! ],
                        ["Intake Notes", dict["PatientAddNotes"]! ],
                        ["Home Address", dict["HomeAddress"]! ],
                        ["City", dict["City"]! ],
                        ["Zip", dict["Zip"]! ],
                        ["Phone", dict["Phone"]! ],
                        ["Cell", dict["Cell"]! ],
                        ["Additional Contact", dict["AdditionalContact"]! ],
                        ["Contact Relationship", dict["ContactRelationship"]! ],
                        ["Contact Phone", dict["ContactPhone"]! ],
                        ["Contact Notes", dict["ContactNotes"]! ],
                        ["Primary Source", dict["PrimarySource"]! ],
                        ["Primary Insurance", dict["PrimarySource"]! ],
                        ["Secondary Insurance", dict["SecondaryCommercial"]! ]
                    ]

                }
            }

            defaults.set(demographics, forKey: "demographics")
            defaults.synchronize()
            
            if let toViewController = segue.destination as? PatientTabBarController {
                
                //send these to PatientTabBarController.swift
                toViewController.segueStoryBoardName = "Refferal"
                                                                                    //toViewController.segueStoryBoardID = "referralVC"
                toViewController.tabBarSeguePatientID =     seguePatientID
                toViewController.tabBarSeguePatientNotes =  seguePatientNotes
                toViewController.tabBarSeguePatientName =   seguePatientName
                toViewController.tabBarSeguePatientCPID =   seguePatientCPID        //appointmentID
                toViewController.tabBarSeguePatientDate =   dateUpToDate            //seguePatientDate
                toViewController.tabBarSegueHourMin =       timeUpToDate            //segueHourMin
                toViewController.tabBarSegueBookMinutes =   lengthOfAppointmentLabel.text! //"15 min" segueBookMinutes
                toViewController.tabBarSegueProviderName =  provider.text!          //"Admin" segueProviderName
                toViewController.tabBarSegueProviderID =    providerID.text!        //"148" segueProviderID
                toViewController.tabBarSegueEncounterType = encounter.text!         //"TCM" segueEncounterType
                toViewController.tabBarSegueEncounterPurpose = purposeOfRefferal.text!//"purpose" segueEncounterPurpose
                toViewController.tabBarSegueLocationType =  placeOfReferral.text!   //"pharmacy" segueLocationType
                toViewController.tabBarSegueBookPlace =     segueBookPlace
                toViewController.tabBarSegueBookAddress =   segueBookAddress
                toViewController.tabBarSeguePreAuth =       priorAuthorizatin.text! //"prior-auth" seguePreAuth
                toViewController.tabBarSegueAttachDoc =     attachDocument.text!    //"did not change" segueAttachDoc
                toViewController.tabBarSegueStatus =        segueStatus
                toViewController.tabBarSegueIsUrgent =      segueIsUrgent
                
            }
        }
    }//prepare(for segue:
    

}
