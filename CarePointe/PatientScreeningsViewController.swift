//
//  PatientScreeningsViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientScreeningsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addScreeningButton: UIButton!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var screeningsTableView: UITableView!
    
    var screeningsData = [
        
            ["FACIT-Pal-14 (Version 4)","11/08/2016","Completed"],
            ["Edmonton Symptom Assessment System Graph (ESAS)","12/31/1969","Completed"],
            ["Hospital Anxiety and Depression Scale (HADS)","11/08/1969","Pending"],
            ["Patient Health Questionnaire","01/12/2014","Pending"],
            ["Hospital Quality Care Survey B","04/07/2016","Completed"]
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegation
        screeningsTableView.delegate = self
        screeningsTableView.dataSource = self

        // UI/UX setup
            // round addScreeningButton button
            addScreeningButton.layer.cornerRadius = 0.5 * addScreeningButton.bounds.size.width
            addScreeningButton.clipsToBounds = true
        
            // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
            let patientName = UserDefaults.standard.string(forKey: "patientName")
            patientNameLabel.text = patientName! + "'s Forms"
        
        //Table ROW Height set to auto layout
        screeningsTableView.rowHeight = UITableViewAutomaticDimension
        screeningsTableView.estimatedRowHeight = 150//was 88 and is 88 in storyboard
    }
    
    
    //
    // #MARK: - Buttons
    //
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "PatientList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientListView") as UIViewController
        //vc.navigationController?.pushViewController(vc, animated: false)
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
    
    //
    // #MARK: - Table View
    //
    
    //1 return # sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //2 return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if(screeningsData.isEmpty == false){
        return screeningsData.count
        }
         else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "screeningscell", for: indexPath) as! ScreeningsCell
        
        cell.screeningName.text = screeningsData[indexPath.row][0]
        cell.screeningDate.text = screeningsData[indexPath.row][1]
        cell.screeningStatus.text = screeningsData[indexPath.row][2]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    //DELETE row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            screeningsData.remove(at: (indexPath as NSIndexPath).row)
            screeningsTableView.reloadData()
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //http://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
//        // " 1. click cell drag to view 2. select the “show” segue in the “Selection Segue” section. "
//        
//        if segue.identifier == "patientViewToDashBoard" {//this is the going back to the main dashboard
//            //do something
//        }
//        else {
//            let selectedRow = ((tableView.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
//            let sectionOfSelectedRow = (tableView.indexPathForSelectedRow?.section)! //retuns int
//            //print("\\(selectedRow)" + " \\(sectionOfSelectedRow)")
//            let patientName = patients[sectionOfSelectedRow][selectedRow]// + "'s Information" as String
//            let appointmentID = appointmentIDs[sectionOfSelectedRow][selectedRow] as String
//            let patientStatus = section[sectionOfSelectedRow]
//            
//            // Store data locally change to mySQL? server later
//            let defaults = UserDefaults.standard
//            defaults.set(patientName, forKey: "patientName")
//            defaults.set(appointmentID, forKey: "appointmentID")
//            defaults.set(patientStatus, forKey: "patientStatus")
//            defaults.synchronize()
//            
//            //            if let dest = segue.destination as? EventViewController {\
//            //                if let eventObject = events[selectedRow] as? Data {
//            //                    let se = NSKeyedUnarchiver.unarchiveObject(with: eventObject) as! ScenarioEvent
//            //                    dest.scenarioEvent = se
//            //                }
//            //            }
//        }
//    }


}








