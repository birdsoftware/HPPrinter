//
//  OrderServiceVC.swift
//  CarePointe
//
//  Created by Brian Bird on 6/7/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class OrderServiceVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //text view
    @IBOutlet weak var messageView: UITextView!
    
    //picker
    @IBOutlet weak var vendorPicker: UIPickerView!
    
    //label
    @IBOutlet weak var cscLabel: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!
    
    //API data
    var restCareT = Array<Dictionary<String,String>>()
    var weHaveCSCToSendTo = false
    var careCoordinatorNameFromAPI = ""
    var careCoordinatorUserIDFromAPI = ""

    var vendorCategory = ["Allergic Medicine", "Assisted Living", "Behavior Health", "Cardiology", "Care Programs", "DME", "Dentistry", "Dermatology (Skin)", "Emergency Room Services", "Gastroenterology", "Home Care", "Home Health", "Hospice", "Hospital", "Hospital to Home", "Imaging and Diagnostic", "Infusion", "Insurance", "Internal Medicine", "Laboratory Tests", "Medical Specialists", "Medical Clinic", "Medical Transfer", "Memory Care", "Mobile Doctors & Nurses", "Obstetrics and Gynecology", "Ophthalmology (Eye)", "Oral Surgery", "Orthodontics", "Orthopedic Surgery", "Otorhinolaryngology (Ear, Nose, Throat)", "Pediatrics", "Pedodontics", "Pharmacy", "Physical Therapy", "Plastic and Reconstructive Surgery", "Primary Care", "Proctology", "Rehabilitation", "Respiratory Medicine", "Rheumatology", "Skilled Nursing Facility/Rehab", "Senior Care Management", "Specialized Care Products", "Social Worker", "Surgery", "Transportation Services", "Urgent Care, Urology"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UI
        messageView.layer.borderWidth = 1.0
        messageView.layer.borderColor = UIColor.Iron().cgColor
        messageView.layer.cornerRadius = 5
        
        // Picker Delegates
        vendorPicker.delegate = self
        vendorPicker.dataSource = self
        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OrderServiceVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        getCSC()
    }

    
    //
    // #MARK: - Supporting Functions
    //
    //This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }
    func segueToPatientTabBar(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientTabBar") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    func getCSC(){
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        // 0 get token again -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        GETToken().signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            let demographics = UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//saved from PatientListVC
            let patientID = demographics[0][1]//"UniqueID"

            let careTeamFlag = DispatchGroup()
            careTeamFlag.enter()
            
            GETCareTeam().getCT(token: token, patientID: patientID, dispachInstance: careTeamFlag)
            
            
            careTeamFlag.notify(queue: DispatchQueue.main) {//GETCareTeam success back from cloud
                
                self.restCareT = UserDefaults.standard.object(forKey: "RESTCareTeam") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
                
                for member in self.restCareT{
                    if member["RoleType"]! == "Care Coordinator"{
                        self.careCoordinatorNameFromAPI = "\(member["caseteam_name"]!)"
                        self.careCoordinatorUserIDFromAPI = "\(member["User_ID"]!)"
                        self.weHaveCSCToSendTo = true
                    }
                }
                
                self.cscLabel.text = "CSC: " + self.careCoordinatorNameFromAPI + " ID: " + self.careCoordinatorUserIDFromAPI
            }
        }
    }
    func sendNewMessageToAPI(){
        ViewControllerUtils().showActivityIndicator(uiView: self.view)
        
        //Data To Send ---------------------
        var messageAPIAtributes = Dictionary<String,String>()
        
        /*Subject*/ messageAPIAtributes["Subject"] = "New Service: \(selectedLabel.text!)"
        /*Message*/ messageAPIAtributes["Msg_desc"] = messageView.text!
       
        if isKeyPresentInUserDefaults(key: "userProfile") {
            let userProfile = UserDefaults.standard.object(forKey: "userProfile") as? Array<Dictionary<String,String>> ?? []
            if userProfile.isEmpty == false {
                let user = userProfile[0]
                /*User_ID*/messageAPIAtributes["SendBy"] = user["User_ID"]!
                
            } else {
                //can't send a message. Your User id not found
            }
        }
 
        let theCSCIDIntFromString = Int(careCoordinatorUserIDFromAPI) ?? 0 //if ID is "" blank then don't crash set to 0. prob never happen since weHaveCSCToSendTo == true to get here

        //--------------------------
        print("Subject:" + "\(messageAPIAtributes["Subject"]!)" + "\n" +
            "Msg_desc:" + "\(messageAPIAtributes["Msg_desc"]!)" + "\n" +
            "SendBy:" + "\(messageAPIAtributes["SendBy"]!)" + "\n" +
            "SendTo:" + "\(theCSCIDIntFromString)" )
        
        //set flag
        let downloadTokenFlag = DispatchGroup()
        downloadTokenFlag.enter()
        
        // 0 get token  -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadTokenFlag)
        
        downloadTokenFlag.notify(queue: DispatchQueue.main)  {//signin API came back
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            let sendMessageFlag = DispatchGroup()
            sendMessageFlag.enter()
            
            //Actual API call
            let passMessageTo = POSTMessage()
            passMessageTo.sendMessage(token: token, message: messageAPIAtributes, SendTo: [theCSCIDIntFromString], dispachInstance: sendMessageFlag)
            
            sendMessageFlag.notify(queue: DispatchQueue.main) {//send message API came back
                
                ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                
                if self.isKeyPresentInUserDefaults(key: "APIsendMessageSuccess") {
                    let isMessageSentWithOutError = UserDefaults.standard.object(forKey: "APIsendMessageSuccess") as? Bool
                    if isMessageSentWithOutError! {
                        //success
                        // ANIMATE  TOAST
                        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
                            
                            self.view.makeToast("Message Sent", duration: 1.1, position: .center)
                            
                        }, completion: { finished in
                            
                            self.segueToPatientTabBar()
                            
                        })
                    } else {
                        //not success
                        self.simpleAlert(title: "Error Sending Message", message: "API messaging error occured. Try again later.", buttonTitle: "OK")
                        
                    }
                }
            }
        }
    }

    //
    // #MARK: - Buttons
    //
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        segueToPatientTabBar()
    }
    @IBAction func sendButtonTapped(_ sender: Any) {
        if weHaveCSCToSendTo == true {
            
            if Reachability.isConnectedToNetwork() == true {
                
                //ATTEMP TO SEND TO API
                self.sendNewMessageToAPI()
                
            } else {
                self.simpleAlert(title: "Error Sending Message", message: "No Internet Connection.", buttonTitle: "OK")
            }
            
        } else {
            //show alert no CSC found
            simpleAlert(title: "No Care Coordinator", message: "No CSC found for this patient contact CarePointe.", buttonTitle: "OK")
        }
    }
    
    //
    // #MARK: - Picker View
    //
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // returns the number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
            
            return vendorCategory.count
    }
    // returns data to display in picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return vendorCategory[row]
    }
    // picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
            selectedLabel.text = vendorCategory[row]
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
