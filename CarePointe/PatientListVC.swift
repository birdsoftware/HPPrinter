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
    var SearchData:Array<Dictionary<String,String>> = []
    
    var patientIDs = [String]()
    var names = [String]()
    var createdDateTime = [String]()
    
    var demographics = [[String]]()
    
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
        
        // change the color of cursol and cancel button.
            patientSearchBar.tintColor = .black
        
        
    }//UserDefaults.standard.set(patientNameID, forKey:"RESTPatientsPatientIDs")


    override func viewWillAppear(_ animated: Bool) {
        
        //let patientData = UserDefaults.standard.object(forKey: "RESTPatientsPatientIDs") as? [[String]] ?? [[String]]()
        // get userData for communication drop down list
        if isKeyPresentInUserDefaults(key: "RESTPatients"){ //"RESTPatientsPatientIDs"){//""userData"){
            patientData = UserDefaults.standard.value(forKey: "RESTPatients") as! Array<Dictionary<String, String>>//"userData") as! Array<Dictionary<String, String>>
        }
        SearchData = patientData
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("PLsearch: \(searchText)")
        let predicate=NSPredicate(format: "SELF.patientName CONTAINS[cd] %@", searchText) // returns .patientName from patientName["patientName"]
        let arr=(patientData as NSArray).filtered(using: predicate)
        
        if arr.count > 0
        {
            SearchData=arr as! Array<Dictionary<String,String>>
        } else {
            SearchData=patientData
        }
        patientTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
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
        if(SearchData.isEmpty == false){
            return SearchData.count
        }
        else {
            return 0
        }
    }
    
    //return actual CELL to be displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientListCell") as! PatientListCell
        
        var Data:Dictionary<String,String> = SearchData[indexPath.row]
        
        cell.patientID.text = Data["Patient_ID"]
        cell.name.text = Data["patientName"]
        cell.status.text = "Status: " + Data["pstatus"]!
        cell.org.text = "Organization: " + Data["organization"]!
        cell.caseProgram.text = "Case Program: " + Data["ReferrerOrigin"]! //case program
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //http://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
        // " 1. click cell drag to view 2. select the “show” segue in the “Selection Segue” section. "
        
        if segue.identifier == "patientDetail"{
            //addBackButton = true
            
            let selectedRow = ((patientTable.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
            
            var Data:Dictionary<String,String> = SearchData[selectedRow]
            
            let patientName = Data["patientName"]
            //let appointmentID = appID[sectionOfSelectedRow][selectedRow] as String
            let patientStatus = "Inactive"//Data["pstatus"]
            let patientImage = "" //appPatImage[sectionOfSelectedRow][selectedRow]
            
            // Store data locally change to mySQL? server later
            let defaults = UserDefaults.standard
            defaults.set(patientName, forKey: "patientName")
            defaults.set(patientImage, forKey: "patientPic")
            defaults.set(patientStatus, forKey: "patientStatus") //need this to hide the accept and decline buttons in completed view
            let dob = convertDateStringToDate(longDate: Data["DOB"]!)
            
            demographics = [
                ["UniqueID", Data["Patient_ID"]! ],
                //["Assigned", "--Waiting for API update--" ],
                ["Gender", Data["Gender"]! ],
                ["Ethnicity", Data["Ethnicity"]! ],
                ["SSN#", Data["SSN"]! ],
                ["DOB", dob],//Data["DOB"]! ],
                ["Primary Language", Data["PrimaryLanguage"]! ],
                ["Email", Data["EmailID"]! ],
                ["Intake Notes", Data["PatientAddNotes"]! ],
                ["Home Address", Data["HomeAddress"]! ],
                ["City", Data["City"]! ],
                ["Zip", Data["Zip"]! ],
                ["Phone", Data["Phone"]! ],
                ["Cell", Data["Cell"]! ],
                ["Additional Contact", Data["AdditionalContact"]! ],
                ["Contact Relationship", Data["ContactRelationship"]! ],
                ["Contact Phone", Data["ContactPhone"]! ],
                ["Contact Notes", Data["ContactNotes"]! ],
                ["Primary Source", Data["PrimarySource"]! ],
                ["Primary Insurance", Data["PrimarySource"]! ],
                ["Secondary Insurance", Data["SecondaryCommercial"]! ]
                ]
            defaults.set(demographics, forKey: "demographics")
            
            defaults.synchronize()
 
            }
            
        }//prepare(for segue:
    

}


