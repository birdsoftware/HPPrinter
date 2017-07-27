//
//  Container3ViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class Container3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //table view
    @IBOutlet weak var allergyTableView: UITableView!

    //API Data
    var allergies = [Dictionary<String,String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegation
        allergyTableView.delegate = self
        allergyTableView.dataSource = self
        allergyTableView.rowHeight = UITableViewAutomaticDimension
        allergyTableView.estimatedRowHeight = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.loadCurrentAllergiesFromJSON()
            }
        }
    }

    
    //
    // MARK: - Supporting Functions
    //
    func loadCurrentAllergiesFromJSON(){
        
        let downloadToken = DispatchGroup(); downloadToken.enter();
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            let downloadAllergies = DispatchGroup(); downloadAllergies.enter();
            
            let getPatient = UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//from PatientListVC
            let patientID = getPatient[0][1]//"UniqueID"
            
            GETAllergies().getCurAllergies(token: token, patientID: patientID, dispachInstance: downloadAllergies)
            
            downloadAllergies.notify(queue: DispatchQueue.main) {
                
                self.allergies = UserDefaults.standard.object(forKey: "RESTCurrentAllergies") as? [Dictionary<String,String>] ?? [Dictionary<String,String>]()
                if self.allergies.isEmpty == false {
                    self.allergyTableView.reloadData()
                }
            }
        }
    }

    func removeAllergy(indexPath: IndexPath){
        
        ViewControllerUtils().showActivityIndicator(uiView: self.view)

        let data = allergies[indexPath.row]
        let allergyId = data["id"]!
        
        let alert = UIAlertController(title: "Do you want to delete this allergy?",
                                      message: "\(data["allergies"]!)",
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            
            // Get 1st TextField's text for Change Log
            //let declineMessage = "Allergy \(allergyId) deleted by . " + alert.textFields![0].text! //print(textField)
            
            // remove Allergy
            //2. Call DELETE API [on sucess] -> 3.update UI
            let downloadToken = DispatchGroup(); downloadToken.enter();
            
            GETToken().signInCarepoint(dispachInstance: downloadToken)
            
            downloadToken.notify(queue: DispatchQueue.main)  {
                
                let token = UserDefaults.standard.string(forKey: "token")!
                
                let removeAnAllergy = DispatchGroup(); removeAnAllergy.enter();
                
                DeleteAllergy().anAllergy(token: token, allergyId: allergyId, dispachInstance: removeAnAllergy)
                
                removeAnAllergy.notify(queue: DispatchQueue.main) {//success
                    
                    // ANIMATE TOAST
                    UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
                        
                        self.view.makeToast("Allergy Deleted", duration: 1.1, position: .center)
                        
                    }, completion: { finished in
                        ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                        self.view.viewWithTag(1)?.removeFromSuperview()//added a tag so this actualy removes the view see activityIndicator.swift
                    })
                    
                    //3. Update UI
                    self.allergies.remove(at: indexPath.row)//self.selectedRow)
                    self.allergyTableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
        
            ViewControllerUtils().hideActivityIndicator(uiView: self.view)
            self.view.viewWithTag(1)?.removeFromSuperview()//added a tag so this actualy removes the view see activityIndicator.swift
        })
        /*
        // Add 1 textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Describe Modifications | Med Rec"
            textField.clearButtonMode = .whileEditing
        }
        */
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)


        
    }
    //
    // MARK: - Table View
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rxcontainer3Cell", for: indexPath) as! RxContainer3Cell
        
        let allergy = allergies[indexPath.row]
        
        cell.allergy.text           =   allergy["allergies"]
        cell.reaction.text          =   allergy["reaction"]
        cell.severity.text          =   allergy["serverity"]
        cell.dateRecognized.text    =   allergy["date_recognized"]
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.polar()  }
        else{
            cell.backgroundColor = UIColor.white  }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
        
        }
        edit.backgroundColor = UIColor.orange
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") {action, index in
            self.removeAllergy(indexPath: indexPath)
        }
        delete.backgroundColor = UIColor.red
        
        return [edit, delete]
    }
    
    /*
    //DELETE row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            //allergyData.remove(at: (indexPath as NSIndexPath).row)
            //allergyTableView.reloadData()
            self.allergies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 */
}
