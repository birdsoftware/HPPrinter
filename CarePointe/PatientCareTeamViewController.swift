//
//  PatientCareTeamViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientCareTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    //table
    @IBOutlet weak var patientCareTeamTable: UITableView!
    
    //buttons
    @IBOutlet weak var sendMessageButton: RoundedButton!
    
    // send message vars
    var isCheckedTeam = [Bool]()
    var recipientNameList = [String]()
    var recipientUserIDList = [String]()
    
    //API data
    var restCareT = Array<Dictionary<String,String>>()
    var viewStatus = ""
    
    var callCareLine = "4804942466"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate 
        patientCareTeamTable.delegate = self //table view
        patientCareTeamTable.dataSource = self
        viewStatus = "viewDidLoad"
        getTokenThenCareTeamFromWebServer(showToast: viewStatus)
        
        //UI 
        sendMessageButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewStatus = "viewWillAppear"
        getTokenThenCareTeamFromWebServer(showToast: viewStatus)
        
    }
    
    //
    //#MARK - Supporting Functions
    //
    func connected(sender: UIButton) {
        
        let buttonTag = sender.tag
        
        let selectedCTData:Dictionary<String,String> = restCareT[buttonTag]
        var phoneString = selectedCTData["phone_number"]!
        if phoneString == "" {
            phoneString = callCareLine
        }
        phoneString = phoneString.replacingOccurrences(of: "(", with: "")
        phoneString = phoneString.replacingOccurrences(of: ")", with: "")
        phoneString = phoneString.replacingOccurrences(of: "-", with: "")
        
        open(scheme: "tel://\(phoneString)")//open(scheme: "tel://8556235691")
    }
    
    func callCareTeamMember(member: Int) {
        open(scheme: "tel://8556235691")//careTeamPhoneNumbers[member])
    }
    
    //Supports CALL
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

    func getTokenThenCareTeamFromWebServer(showToast: String) {
    
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        // 0 get token again -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            var dontShowToast = true //if viewDidLoad - don't 2x TOAST
            if(showToast == "viewWillAppear") { dontShowToast = false}
            
            //GET VITALS---------------------
            self.getCareTeamFromWebServer(token: token, dontShowToast:dontShowToast)
            //-------------------------------
        }
        
    }
    
    func getCareTeamFromWebServer(token: String, dontShowToast: Bool) {
    
        let demographics = UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//saved from PatientListVC
        let patientID = demographics[0][1]//"UniqueID"
        
        print("patientID: \(patientID)")
        
        let careTeamFlag = DispatchGroup()
        careTeamFlag.enter()

        let ct = GETCareTeam()
        ct.getCT(token: token, patientID: patientID, dispachInstance: careTeamFlag)
        
        
        careTeamFlag.notify(queue: DispatchQueue.main) {//ct sent back from cloud
            
            self.restCareT = UserDefaults.standard.object(forKey: "RESTCareTeam") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
            
            for _ in self.restCareT{
                self.isCheckedTeam.append(false)
            }
            
            if(dontShowToast == false){
                let rCTCount = self.restCareT.count
                self.view.makeToast("\(rCTCount) Care Team members pulled from cloud", duration: 1.1, position: .center)
            }
            
            self.patientCareTeamTable.reloadData()
            
        }

    }
    
    //
    // MARK: - Button Actions
    //
    
    @IBAction func unwindToPatientDashboardButtonTapped(_ sender: Any) {
        //1. palce "@IBAction func unwindToPatientDashboard(segue: UIStoryboardSegue) {}" in view controller you want to unwind too
        //2. In storyboard connect this view () -> to [exit]: creates "Unwind segue" in this view not view unwind too
        //   In storyboard click "Unwind segue" set unwind segue identifier: "unwindToPatientDB"
        //                                                           Action: "unwindToPatientDashboardWithSegue:"
        //3. Trigger unwind segue programmatically (below)
        self.performSegue(withIdentifier: "unwindToPatientDB", sender: self)
    }
    
    
    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return restCareT.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        let cell: PatientCareTeamCell = tableView.dequeueReusableCell(withIdentifier: "patientCareTeamCell") as! PatientCareTeamCell
        
        let careTeamData:Dictionary<String,String> = restCareT[IndexPath.row]
        
        if careTeamData["phone_number"] == "" {
            //cell.patientCTCallButton.isEnabled = false
            let stencil = UIImage(named: "phoneCircle.png")?.withRenderingMode(.alwaysTemplate)
            cell.patientCTCallButton.setImage(stencil, for: .normal)
            cell.patientCTCallButton.tintColor = .red // set a color
        } //else {
            //set tag of the button since we are using it & add target to the buttom
            cell.patientCTCallButton.tag = IndexPath.row //tag is Int -2,147,483,648 and 2,147,483,647
            cell.patientCTCallButton.addTarget(self, action: #selector(connected), for: .touchUpInside)
        //}
        cell.patientCTVideoButton.isEnabled = false
        
        cell.patientCTMessageButton.isHidden = true
        //cell.patientCTMessageButton.tag = IndexPath.row
        //cell.patientCTMessageButton.addTarget(self, action: #selector(autoMessage), for: .touchUpInside)
        
        cell.patientCareTeamName.text = careTeamData["caseteam_name"]
        cell.patientCareTeamPosition.text = careTeamData["RoleType"]
        
        let accessory: UITableViewCellAccessoryType = isCheckedTeam[IndexPath.row] ? .checkmark : .none
        cell.accessoryType = accessory
        // cell.selectionStyle = .none if you want to avoid the cell being highlighted on selection then uncomment
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let careTeamData:Dictionary<String,String> = restCareT[indexPath.row]
        let selectedName = careTeamData["caseteam_name"]
        let selectedUserID = careTeamData["User_ID"]
        
        if indexPath.row < isCheckedTeam.count
        {
            let boolChecked = isCheckedTeam[indexPath.row]
            isCheckedTeam[indexPath.row] = !boolChecked
            
            if !boolChecked {
                recipientNameList.append(selectedName!)
                recipientUserIDList.append(selectedUserID!)
            } else {
                recipientNameList = recipientNameList.filter{$0 != selectedName!}
                recipientUserIDList = recipientUserIDList.filter{$0 != selectedUserID!}
            }
            
            let numberOfTrue = isCheckedTeam.filter{$0}.count
            
            if numberOfTrue > 0 {
                sendMessageButton.isHidden = false
                sendMessageButton.setTitle("Send Message \(numberOfTrue)", for: .normal)
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            } else {
                sendMessageButton.isHidden = true
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
            
            //print("\(recipientNameList)")
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.accessoryType = .checkmark
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.accessoryType = .none
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "teamReplyMessage" {
            //let buttonTag = sender.tag
            //let selectedRow = ((patientCareTeamTable.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
            //let selectedCTData:Dictionary<String,String> = restCareT[buttonTag]
            
            //let userID = selectedCTData["User_ID"]!
           // let teamMemberName = selectedCTData["caseteam_name"]!
            
            //segue out varaibles
            var recipientList = ""//teamMemberName//""
            var userIDs = ""
            
            for recipient in recipientNameList{
                //let userName = user["FirstLastName"]!
                recipientList += " \(recipient),"
            }
            for userID in recipientUserIDList{
                userIDs += " \(userID),"
            }
            
            let currentTime = returnCurrentDateOrCurrentTime(timeOnly: true)//4:41 PM
            let todaysDate = returnCurrentDateOrCurrentTime(timeOnly: false)//"2/14/2017"
            
            if let toViewController = segue.destination as? /*1 sendTo AMessageViewController*/ newMessageViewController {
                /*maker sure .segueFromList is a var delaired in sendTo ViewController*/
                toViewController.isReply = true
                toViewController.segueFromList = recipientList//segueFromList
                toViewController.segueDate = todaysDate + " " + currentTime //"3/2/17 11:32 AM"
                toViewController.segueSubject = ""// + segueSubject
                toViewController.segueMessage =  ""//"\n>" + segueMessage
                toViewController.segueUserID = userIDs//""
                toViewController.segueBACKStoryBoard = "Main"
                toViewController.segueBACKSBID = "PatientTabBar"
            }
            
        }
        if segue.identifier == "teleConnectSegue" {
            
        }
    }

    
//    func autoMessage(sender: UIButton){
//        let buttonTag = sender.tag
//        
//        let selectedCTData:Dictionary<String,String> = restCareT[buttonTag]
//        let userID = selectedCTData["User_ID"]!
//        let teamMemberName = selectedCTData["caseteam_name"]!
//        
//    }
    
    
}
