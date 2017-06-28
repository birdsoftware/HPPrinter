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
                    //print(self.allergies)
                    self.allergyTableView.reloadData()
                }
            }
        }
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
    
    //DELETE row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            //allergyData.remove(at: (indexPath as NSIndexPath).row)
            //allergyTableView.reloadData()
            self.allergies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
