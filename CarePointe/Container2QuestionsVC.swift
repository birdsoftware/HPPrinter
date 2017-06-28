//
//  Container2QuestionsVC.swift
//  CarePointe
//
//  Created by Brian Bird on 5/19/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class Container2QuestionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //table view
    @IBOutlet weak var questionTable: UITableView!
    
    //edit button
    @IBOutlet weak var sendEditButton: RoundedButton!
    
    @IBOutlet weak var completeQuestionnaireLabel: UILabel!
    
    var questionnaireQuestionLabels = [
        
        "Can Patient self-medicate?",
        "Is Patient understood what medications is for and describe use?",
        "Can Patient afford their medications?",
        "Is patient on high risk medications? If yes please note Anticoagulant, antibiotics, steroids, opioids?",
        "Does patient have any intolerance or allergies to meds?",
        "Does patient feel meds are effective?",
        "Is patient taking as prescribed?",
        "Does patient know how to monitor PRN meds?",
        "Has patient missed any doses?",
        "Does Patient or technician have any additional concerns?"
    ]
    
    var qSwitchBools = ["no","no","no","no","no",
                        "no","no","no","no","no"]
    
    var questionNotes = ["","","","","",
                         "","","","",""]
    
    //API Data
    var questinnaireData = [Dictionary<String,String>]()
    var recipients:Array<Dictionary<String,String>> = []
    
    //TODO:
    //ADD button to last cell
    //https://stackoverflow.com/questions/24566809/how-to-make-uibutton-appear-in-last-cell-only
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegation
        questionTable.delegate = self
        questionTable.dataSource = self
        questionTable.rowHeight = UITableViewAutomaticDimension
        questionTable.estimatedRowHeight = 100
        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.loadCurrentQuestinnaireForGivenPatientFromJSON()
            }
        }
    }
    
    //
    // MARK: - Supporting Functions
    //
    func loadCurrentQuestinnaireForGivenPatientFromJSON(){
        
        let downloadToken = DispatchGroup(); downloadToken.enter();
        
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            let downloadQuestions = DispatchGroup(); downloadQuestions.enter();
            
            let demographics = UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//saved from PatientListVC
            let patientID = demographics[0][1]//"UniqueID"
            
            GETQuestinnaire().getCurQuestions(token: token, patientID: patientID, dispachInstance: downloadQuestions)
            
            downloadQuestions.notify(queue: DispatchQueue.main) {
                
                let Questinnaire = UserDefaults.standard.object(forKey: "RESTCurrentQuestinnaire") as? [Dictionary<String,String>] ?? [Dictionary<String,String>]()
                if Questinnaire.isEmpty == false {
                    self.qSwitchBools[0] = Questinnaire[0]["question1"]!
                    self.qSwitchBools[1] = Questinnaire[0]["question2"]!
                    self.qSwitchBools[2] = Questinnaire[0]["question3"]!
                    self.qSwitchBools[3] = Questinnaire[0]["question4"]!
                    self.qSwitchBools[4] = Questinnaire[0]["question5"]!
                    self.qSwitchBools[5] = Questinnaire[0]["question6"]!
                    self.qSwitchBools[6] = Questinnaire[0]["question7"]!
                    self.qSwitchBools[7] = Questinnaire[0]["question8"]!
                    self.qSwitchBools[8] = Questinnaire[0]["question9"]!
                    self.qSwitchBools[9] = Questinnaire[0]["question10"]!
                    self.questionNotes[0] = Questinnaire[0]["comment1"]!
                    self.questionNotes[1] = Questinnaire[0]["comment2"]!
                    self.questionNotes[2] = Questinnaire[0]["comment3"]!
                    self.questionNotes[3] = Questinnaire[0]["comment4"]!
                    self.questionNotes[4] = Questinnaire[0]["comment5"]!
                    self.questionNotes[5] = Questinnaire[0]["comment6"]!
                    self.questionNotes[6] = Questinnaire[0]["comment7"]!
                    self.questionNotes[7] = Questinnaire[0]["comment8"]!
                    self.questionNotes[8] = Questinnaire[0]["comment9"]!
                    self.questionNotes[9] = Questinnaire[0]["comment10"]!
                    
                    let dateString = self.convertDateStringToDate(longDate: Questinnaire[0]["date_time"]! )
                    let editorValue = Questinnaire[0]["added_by"]!//"1" or "331", etc
                    let editorName = self.returnName(userID: editorValue)
                    self.completeQuestionnaireLabel.text = "Updated by \(editorName) on \(dateString)"
                    self.sendEditButton.setTitle("Edit", for: .normal)
                    
                    self.questionTable.reloadData()
                }
            }
        }
    }
    func getLocalMessageUsers(defaultKey: String, arrayDicts: inout Array<Dictionary<String,String>>){
        if isKeyPresentInUserDefaults(key: defaultKey){
            arrayDicts = UserDefaults.standard.object(forKey: defaultKey) as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
        }
    }
    
    //To search the array for a particular key/value pair:
    func returnName(userID:String) -> String {
        
        getLocalMessageUsers(defaultKey: "RESTInboxUsers", arrayDicts: &recipients)
        
        var name = userID//user["FirstLastName"]!
        var isFound = false
        for recipient in recipients{
            if recipient["User_ID"] == userID {
                name = recipient["FirstLastName"]!
                isFound = true
            }
        }
        if isFound == false {
            name = "Admin"
        }
        
        return name
    }


    //This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //
    // MARK: - Table View
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionnaireQuestionLabels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rxcontainer2Cell", for: indexPath) as! RxContainer2Cell
        
        cell.question.text = questionnaireQuestionLabels[indexPath.row]
        let stringYesNo = qSwitchBools[indexPath.row]
        cell.qSwitch.isOn = ( stringYesNo == "yes" ? true : false )
        cell.note.text = questionNotes[indexPath.row]
        
        //note: UITextField!
        //qSwitch: UISwitch!
        
        return cell
    }
}
