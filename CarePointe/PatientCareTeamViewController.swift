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
    
    //API data
    var restCareT = Array<Dictionary<String,String>>()
    var viewStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate 
        patientCareTeamTable.delegate = self //table view
        patientCareTeamTable.dataSource = self
        viewStatus = "viewDidLoad"
        getTokenThenCareTeamFromWebServer(showToast: viewStatus)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewStatus = "viewWillAppear"
        getTokenThenCareTeamFromWebServer(showToast: viewStatus)
        
    }
    
    //
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
            cell.patientCTCallButton.isEnabled = false
        } else {
            //set tag of the button since we are using it & add target to the buttom
            cell.patientCTCallButton.tag = IndexPath.row //tag is Int -2,147,483,648 and 2,147,483,647
            cell.patientCTCallButton.addTarget(self, action: #selector(connected), for: .touchUpInside)
        }
        cell.patientCTVideoButton.isEnabled = false
        cell.patientCTMessageButton.isEnabled = false
        
        cell.patientCareTeamName.text = careTeamData["caseteam_name"]
        cell.patientCareTeamPosition.text = careTeamData["caseteam_name"]
        return cell
    }
    
    func connected(sender: UIButton) {
        
        let buttonTag = sender.tag
       
        let selectedCTData:Dictionary<String,String> = restCareT[buttonTag]
        var phoneString = selectedCTData["phone_number"]!
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
    
}
