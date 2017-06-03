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
    
    var questionData = [
        
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
    
    //Allergic Medicine, Assisted Living, Behavior Health, Cardiology, Care Programs, DME, Dentistry, Dermatology (Skin), Emergency Room Services, Gastroenterology, Home Care, Home Health, Hospice, Hospital, Hospital to Home, Imaging and Diagnostic, Infusion, Insurance, Internal Medicine, Laboratory Tests, Medical Specialists, Medical Clinic, Medical Transfer, Memory Care, Mobile Doctors & Nurses, Obstetrics and Gynecology, Ophthalmology (Eye), Oral Surgery, Orthodontics, Orthopedic Surgery, Otorhinolaryngology (Ear, Nose, Throat), Pediatrics, Pedodontics, Pharmacy, Physical Therapy, Plastic and Reconstructive Surgery, Primary Care, Proctology, Rehabilitation, Respiratory Medicine, Rheumatology, Skilled Nursing Facility/Rehab, Senior Care Management, Specialized Care Products, Social Worker, Surgery, Transportation Services, Urgent Care, Urology
    
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

    //This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //2 return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(questionData.isEmpty == false){
            return questionData.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rxcontainer2Cell", for: indexPath) as! RxContainer2Cell
        
        cell.question.text = questionData[indexPath.row]
        
//        if(indexPath.row % 2 == 0){
//            cell.backgroundColor = UIColor.polar()  }
//        else{
//            cell.backgroundColor = UIColor.white  }
        
        return cell
    }

}
