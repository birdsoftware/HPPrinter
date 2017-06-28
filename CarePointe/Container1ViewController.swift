//
//  Container1ViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class Container1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //table view
    @IBOutlet weak var medicationTableView: UITableView!
    
    var medicationData = [
        ["medications":"", "dosage":"", "frequency":"", "route":"", "UNITS":"", "REFILLCOUNT":""]
    ]
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegation
        medicationTableView.delegate = self
        medicationTableView.dataSource = self
        
        //auto resize table height (grow with more content)
        medicationTableView.rowHeight = UITableViewAutomaticDimension
        medicationTableView.estimatedRowHeight = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.loadCurrentMedsForGivenPatientFromJSON() //{"drugId":"17012","drugName":"ABIRATERONE"}
                //print(self.tableMeds.count)
                //self.medicationData = loadMedicationsFromJSON()
                //self.loadingView.removeFromSuperview()
            }
        }
    }
    
    
    //
    // #MARK: - Table View
    //
    
    //1 return # sections
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    //2 return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rxcontainer1Cell", for: indexPath) as! RxContainer1Cell
        
        let data = medicationData[indexPath.row]
        
        cell.medicationTitle.text = data["medications"]//medicationData[indexPath.row][0]
        cell.dosage.text =          data["dosage"]//medicationData[indexPath.row][1]
        cell.frequency.text =       data["frequency"]//medicationData[indexPath.row][2]
        cell.route.text =           data["route"]//medicationData[indexPath.row][3]
        cell.unit.text =            data["UNITS"]//medicationData[indexPath.row][4]
        cell.refill.text =          data["REFILLCOUNT"]//medicationData[indexPath.row][5]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let more = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.selectedRow = indexPath.row
            self.editMedication()
            print("Edit button tapped")
        }
        more.backgroundColor = UIColor.orange
    
        let favorite = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //self.isEditing = false
            self.medicationData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Delete button tapped")
        }
        favorite.backgroundColor = UIColor.red
        
        let share = UITableViewRowAction(style: .normal, title: "Discontinue") { action, index in
            //self.isEditing = false
            print("Discontinue button tapped")
        }
        share.backgroundColor = UIColor.blue
        
        return [share, favorite, more]
    }
    
    
    //
    // MARK: - Supporting Functions
    //
    func editMedication(){
        //Med List
        self.performSegue(withIdentifier: "Container1ToAddEditRx", sender: self)
    }
    func loadCurrentMedsForGivenPatientFromJSON(){
        
        let demographics = UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//saved from PatientListVC
        let patientID = demographics[0][1]//"UniqueID"
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            let downloadCurMeds = DispatchGroup()
            downloadCurMeds.enter()
        
            GETMeds().getCurMeds(token: token, patientID: patientID, dispachInstance: downloadCurMeds)
            
            downloadCurMeds.notify(queue: DispatchQueue.main) {
                
                let meds = UserDefaults.standard.object(forKey: "RESTCurrentMedications") as? [Dictionary<String,String>] ?? [Dictionary<String,String>]()
                self.medicationData = meds
                self.medicationTableView.reloadData()
                //print(meds)
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "Container1ToAddEditRx" {
            
            if let toVC = segue.destination as? AddEditRxVC {
                
                //let selectedRow = ((medicationTableView.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
                
                let data = medicationData[selectedRow]
                
                toVC.segueMedication = data["medications"]
                toVC.segueDosage = data["dosage"]
                toVC.segueFrequency = data["frequency"]
                toVC.segueRoute = data["route"]
                toVC.segueUnits = data["UNITS"]
                toVC.segueRefillcount = data["REFILLCOUNT"]
                
            }
        }
        
    }
    
}
