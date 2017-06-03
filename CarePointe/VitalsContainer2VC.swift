//
//  VitalsContainer2VC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/8/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class VitalsContainer2VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var vitalsTable: UITableView!
    
    @IBOutlet weak var vitalsTitle: UILabel!
    
    
    var vitals = [[String]]()
    var restVital = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //delegation
        vitalsTable.delegate = self
        vitalsTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        vitalsTable.rowHeight = UITableViewAutomaticDimension
        vitalsTable.estimatedRowHeight = 150
        
        vitals = [["Height inches","-in"],//"5ft 7 in"
                        ["Weight lbs","-lbs"],//"140 lbs"
                        ["BMI","-"],//27.6
                        ["BMI Status","-"],//moderate
                        ["Body Temperature ℉","-℉"],//"98.3 ℉"
                        ["BP-Sitting Sys/Dia","-/-"],//180/70
                        ["Respitory Rate %","-%"]//100%
        ]
        
        getTokenThenVitalsFromWebServer()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTokenThenVitalsFromWebServer()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // #MARK: - Supporting Functions
    //
    
    func getTokenThenVitalsFromWebServer() {
    
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        // 0 get token again -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
        
        let token = UserDefaults.standard.string(forKey: "token")!
        
        //GET VITALS---------------------
        self.getVitalsFromWebServer(token: token)
        //------------
        }
    }

    
    func getVitalsFromWebServer(token: String){
    
        let demographics = UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//saved from PatientListVC
        let patientID = demographics[0][1]//"UniqueID"
        
        print("patientID: \(patientID)")
        
        let vitalsFlag = DispatchGroup()
        vitalsFlag.enter()
        
        let Gvitals = GETVitals()
        Gvitals.getVitals(token: token, patientID: patientID, dispachInstance: vitalsFlag)
        
        vitalsFlag.notify(queue: DispatchQueue.main) {//vitals sent back from cloud
        
        self.restVital = UserDefaults.standard.object(forKey: "RESTVitals") as? [String] ?? [String]()
        
            let vitalsCount = self.restVital.count
            self.view.makeToast("\(vitalsCount) vitals pulled from cloud", duration: 1.1, position: .center)
            
        if self.restVital.isEmpty == false {
        
            for index in 0..<self.vitals.count {
        
                if self.restVital[index].isEmpty == false {
                    self.vitals[index][1] = self.restVital[index]
                } else {
                    self.vitals[index][1] = "-"
                }
        }
        
        let shortDate = self.convertDateStringToDate(longDate: self.restVital[7])
        self.vitalsTitle.text = "Current Vitals: | " + shortDate
        
        }

        print("vv: \(self.restVital)")
        
        self.vitalsTable.reloadData()
        
        }
    }

    func saveVitalsToWebServer(height:String, weight:String, bmi:String, bmiStatus:String,
                               bodyTemp:String, bpLocation:String, respRate: String ){
        
        let demographics = UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//saved from PatientListVC
        let patientID = demographics[0][1]//"UniqueID"
        
        print("patientID: \(patientID)")
        
        /**/let downloadToken = DispatchGroup()
        /**/downloadToken.enter()
        
        // 0 get token again -----------
        /**/let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        /**/let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        /**/let getToken = GETToken()
        /**/getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  { //download token successful now get vitals
            
            let token = UserDefaults.standard.string(forKey: "token")!
            //SAVE local with any changes to web server
            
            
            /**/let serverSavedVitals = DispatchGroup()
            /**/serverSavedVitals.enter()
            
            let v = PUTVitals()
            v.updateVitals(token: token, patientID: patientID, height: height, weight: weight, bmi: bmi, bmiStatus: bmiStatus, bodyTemp: bodyTemp, bpLocation: bpLocation, respRate: respRate, dispachInstance: serverSavedVitals)
            
            serverSavedVitals.notify(queue: DispatchQueue.main) {//serverSavedVitals now what?
                
                //print("got here \(height) \(weight) \(bmi) \(bmiStatus) \(bodyTemp) \(bpLocation) \(respRate)")
                self.view.makeToast("Vitals saved to cloud", duration: 1.1, position: .center)
            }

        }
        
    }
    
    
    //
    // #MARK: - Button Action
    //
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        // Show Alert, get new vitals[n] text, show [Update] [Cancel] buttons
        let alert = UIAlertController(title: "Patient Vitals",
                                      message: "Update patient vitals",
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Update now", style: .default, handler: { (action) -> Void in
            // Get 6 TextField's text
            var heightTextField = alert.textFields![0].text!
            var weightTextField = alert.textFields![1].text! //print(textField)
            var bmiTextField = alert.textFields![2].text!
            var bmiStatusTextField = alert.textFields![3].text!
            var bodyTempTextField = alert.textFields![4].text!
            var bpLocationTextField = alert.textFields![5].text!
            var respRate = alert.textFields![6].text!
            
            //check for empty fields
            if (heightTextField.isEmpty == false) {
                self.vitals[0][1] = heightTextField
            } else {
                heightTextField = self.restVital[0]// == false ? self.restVital[0]:"1")
            }
            if (weightTextField.isEmpty == false) {
                self.vitals[1][1] = weightTextField
            } else {
                weightTextField = self.restVital[1]// ? self.restVital[1]:"1")
            }
            if (bmiTextField.isEmpty == false) {
                self.vitals[2][1] = bmiTextField
            } else {
                bmiTextField = self.restVital[2]//.isEmpty == false// ? self.restVital[2]:"1")
            }
            if (bmiStatusTextField.isEmpty == false) {
                self.vitals[3][1] = bmiStatusTextField
            } else {
                bmiStatusTextField = self.restVital[3]//.isEmpty == false ? self.restVital[3]:"1")
            }
            if (bodyTempTextField.isEmpty == false) {
                self.vitals[4][1] = bodyTempTextField
            } else {
                bodyTempTextField = self.restVital[4]//.isEmpty == false ? self.restVital[4]:"1")
            }
            if (bpLocationTextField.isEmpty == false) {
                self.vitals[5][1] = bpLocationTextField
            } else {
                bpLocationTextField = self.restVital[5]//.isEmpty == false ? self.restVital[5]:"1")
            }
            if (respRate.isEmpty == false) {
                self.vitals[6][1] = respRate//.text!
            } else {
                respRate = self.restVital[6]//.isEmpty == false ? self.restVital[6]:"1")
            }
            
            self.vitalsTitle.text = "Current Vitals: | " + self.returnCurrentDateOrCurrentTime(timeOnly: false)
            
            self.saveVitalsToWebServer(height:heightTextField, weight:weightTextField,
                                       bmi:bmiTextField, bmiStatus:bmiStatusTextField,
                                       bodyTemp:bodyTempTextField, bpLocation:bpLocationTextField, respRate: respRate )
            
            self.vitalsTable.reloadData()
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // Add Height textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New Height inches"
            textField.clearButtonMode = .whileEditing
            
        }
        // Add Weight textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New Weight lbs"
            textField.clearButtonMode = .whileEditing
            
        }
        // Add BMI textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New BMI"
            textField.clearButtonMode = .whileEditing
        }
        // Add BMI Status textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New BMI Status"
            textField.clearButtonMode = .whileEditing
        }
        // Add Body Temperature textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New Body Temperature ℉"
            textField.clearButtonMode = .whileEditing
        }
        // Add textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New BP-Sitting Sys/Dia"
            textField.clearButtonMode = .whileEditing
        }
        // Add textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New Respitory Rate %"
            textField.clearButtonMode = .whileEditing
        }
        
        //let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 1.80)
       // alert.view.addConstraint(height)
        
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vitals.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vitals") as! vitalsCell
        
        cell.label.text = vitals[IndexPath.row][0]
        cell.details.text = vitals[IndexPath.row][1]
        
        if(IndexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.polar()  }
        else{
            cell.backgroundColor = UIColor.white  }
        
        return cell
    }
    
    
    
    
    
}
