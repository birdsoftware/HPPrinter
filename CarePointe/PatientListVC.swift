//
//  PatientListVC.swift
//  CarePointe
//
//  Created by Brian Bird on 4/14/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    //table view
    @IBOutlet weak var patientTable: UITableView!
    
    //search bar
    @IBOutlet weak var patientSearchBar: UISearchBar!
    
    // class vars
    var searchActive : Bool = false
    var patientData:Array<Dictionary<String,String>> = []
    var patientIDs = [String]()
    var names = [String]()
    var createdDateTime = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //table view delegate
        patientTable.delegate = self
        patientTable.dataSource = self
        
        //search delegate
        patientSearchBar.delegate = self
        
        //Table ROW Height set to auto layout (patient name set to grow to 2 lines)
        patientTable.rowHeight = UITableViewAutomaticDimension
        patientTable.estimatedRowHeight = 90
        
        
    }//UserDefaults.standard.set(patientNameID, forKey:"RESTPatientsPatientIDs")


    override func viewWillAppear(_ animated: Bool) {
        
        //let patientData = UserDefaults.standard.object(forKey: "RESTPatientsPatientIDs") as? [[String]] ?? [[String]]()
        // get userData for communication drop down list
        if isKeyPresentInUserDefaults(key: "RESTPatientsPatientIDs"){//""userData"){
            patientData = UserDefaults.standard.value(forKey: "RESTPatientsPatientIDs") as! Array<Dictionary<String, String>>//"userData") as! Array<Dictionary<String, String>>
        }
        
        patientTable.reloadData()
    }
    
    // Buttons
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController
        //vc.navigationController?.pushViewController(vc, animated: false)
        self.present(vc, animated: false, completion: nil)
        
    }

    //
    // #MARK: - Search Functions
    //
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        patientSearchBar.text = ""
        patientSearchBar.endEditing(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        //alertSearchBar.endEditing(true)
    }

    

    //
    // #MARK: - Table View
    //
    
    //return number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(patientData.isEmpty == false){
            return patientData.count
        }
        else {
            return 0
        }
    }
    
    //return actual CELL to be displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientListCell") as! PatientListCell
        
        var Data:Dictionary<String,String> = patientData[indexPath.row]
        
        cell.patientID.text = Data["Patient_ID"]
        cell.name.text = Data["patientName"]
        cell.date.text = "\u{F098}"//Data["CreatedDateTime"]
        
        return cell
    }

}


