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
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.selectedRow = indexPath.row
            self.editMedication()
            print("Edit button tapped")
        }
        edit.backgroundColor = UIColor.orange
    
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //self.selectedRow = indexPath.row
            self.removeMedication(indexPath: indexPath, typeString: "Delete")
            //self.medicationData.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            print("Delete button tapped")
        }
        delete.backgroundColor = UIColor.red
        
        let discontinue = UITableViewRowAction(style: .normal, title: "Discontinue") { action, index in
            //self.isEditing = false
            print("Discontinue button tapped")
            self.removeMedication(indexPath: indexPath, typeString: "Discontinue")
        }
        discontinue.backgroundColor = UIColor.blue
        
        return [edit, delete, discontinue]
    }
    
    
    //
    // MARK: - Supporting Functions
    //
    //hold this reference in your class
    weak var AddAlertSaveAction: UIAlertAction?
    
    func removeMedication(indexPath: IndexPath, typeString: String){
        
        ViewControllerUtils().showActivityIndicator(uiView: self.view)
        
        let data = medicationData[indexPath.row]
        let medicaitonID = data["id"]!
        //let typeString:String = isDiscontinue ? "Discontinue" : "Delete"
        
        //1. Display alert and get message, save locally, later update Change Log on web app
        //"Do you want to delete this medication?" [YES] -> "Describe Modifications | Medication Reconciliation" [SAVE]
        let alert = UIAlertController(title: typeString+" this medication? Please provide Med Rec below.",
                                      message: "\(data["medications"]!)",
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            
            // Get 1st TextField's text for Change Log
            let declineMessage = "Medication \(medicaitonID) "+typeString+" by . " + alert.textFields![0].text! //print(textField)
            
            // remove medication
             //2. Call DELETE API [on sucess] -> 3.update UI
            let downloadToken = DispatchGroup(); downloadToken.enter()
             
             GETToken().signInCarepoint(dispachInstance: downloadToken)
             
             downloadToken.notify(queue: DispatchQueue.main)  {
             
                 let token = UserDefaults.standard.string(forKey: "token")!
                 
                let removeAMed = DispatchGroup(); removeAMed.enter()
                 
                 DeleteMed().aCurrentMed(token: token, medId: medicaitonID, dispachInstance: removeAMed)
                 
                 removeAMed.notify(queue: DispatchQueue.main) {//success
                    
                    // ANIMATE TOAST
                    UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
                        
                        self.view.makeToast("Medication "+typeString+"d", duration: 1.1, position: .center)
                        
                    }, completion: { finished in
                        ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                        self.view.viewWithTag(1)?.removeFromSuperview()//added a tag so this actualy removes the view see activityIndicator.swift
                    })
                 
                    //3. Update UI
                    self.medicationData.remove(at: indexPath.row)//self.selectedRow)
                    self.medicationTableView.deleteRows(at: [indexPath], with: .fade)
                 }
             }
            
        })
        
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            
            ViewControllerUtils().hideActivityIndicator(uiView: self.view)
            self.view.viewWithTag(1)?.removeFromSuperview()//added a tag so this actualy removes the view see activityIndicator.swift
        })
        
        // Add 1 textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Describe Modifications | Med Rec"
            textField.clearButtonMode = .whileEditing
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }
        
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        AddAlertSaveAction = submitAction
        AddAlertSaveAction?.isEnabled = false
        present(alert, animated: true, completion: nil)

        
        
    }
    func textChanged(_ sender:UITextField) {
        AddAlertSaveAction?.isEnabled = !(sender.text?.isEmpty)!//enable submitAction button if text field not empty
    }
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
    
    //
    // MARK: - Segue
    //
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
