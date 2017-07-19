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
    
    //segment control
    @IBOutlet weak var scopeSegmentControl: UISegmentedControl!
    
    //autolayout
    @IBOutlet weak var segementControlHeight: NSLayoutConstraint!
    
    //search bar
    @IBOutlet weak var patientSearchBar: UISearchBar!
    
    //label
    @IBOutlet weak var myPatientsLabel: UILabel!
    
    //pull to refresh
    private let refreshControl = UIRefreshControl()
    
    // class vars
    var searchActive : Bool = false
    var patientData:Array<Dictionary<String,String>> = []
    var SearchData:Array<Dictionary<String,String>> = []
    //var ScopeData:Array<Dictionary<String,String>> = []
    
    var patientIDs = [String]()
    var names = [String]()
    var createdDateTime = [String]()
    
    var demographics = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pull to refresh
        //let refreshControl = UIRefreshControl()
        patientTable.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(PatientListVC.refreshData), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Patients ...")
        
        scopeSegmentControl.isHidden = true
        segementControlHeight.constant = 0
        
        //table view delegate
        patientTable.delegate = self
        patientTable.dataSource = self
        
        //search delegate
        patientSearchBar.delegate = self
        patientSearchBar.scopeButtonTitles = ["All","Active","Not Active"]
        
        //Table ROW Height set to auto layout (patient name set to grow to 2 lines)
        patientTable.rowHeight = UITableViewAutomaticDimension
        patientTable.estimatedRowHeight = 90
        
        // change the color of cursol and cancel button.
            //patientSearchBar.tintColor = .white//.black
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // get userData for communication drop down list
        if isKeyPresentInUserDefaults(key: "RESTPatients"){
            patientData = UserDefaults.standard.value(forKey: "RESTPatients") as! Array<Dictionary<String, String>>
        }
        patientData.sort { $0["patientName"]! < $1["patientName"]! }//sort arry in place
        SearchData = patientData
        //ScopeData = SearchData
        patientTable.reloadData()
        let patientCount = patientData.count//ScopeData.count
        myPatientsLabel.text = "My Patients (\(patientCount))"
    }
    
    
    //
    // #MARK: - Button Actions
    //
    @IBAction func backButtonTapped(_ sender: Any) {
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController
        //vc.navigationController?.pushViewController(vc, animated: false)
        self.present(vc, animated: false, completion: nil)
    }
    
//    @IBAction func scopeSegmentTapped(_ sender: Any) {
//        
//        var scopePredicate:NSPredicate
//        
//        switch scopeSegmentControl.selectedSegmentIndex
//        {
//        case 0:
//            SearchData=patientData
//            patientTable.reloadData()
//
//        case 1:
//            scopePredicate = NSPredicate(format: "SELF.pstatus MATCHES[cd] %@", "Active")
//            let arr=(patientData as NSArray).filtered(using: scopePredicate)
//            if arr.count > 0
//            {
//                SearchData=arr as! Array<Dictionary<String,String>>
//            } else {
//                SearchData=patientData
//            }
//            patientTable.reloadData()
//
//        case 2:
//            scopePredicate = NSPredicate(format: "NOT SELF.pstatus MATCHES[cd] %@", "Active")
//            let arr=(patientData as NSArray).filtered(using: scopePredicate)
//            if arr.count > 0
//            {
//                SearchData=arr as! Array<Dictionary<String,String>>
//            } else {
//                SearchData=patientData
//            }
//            patientTable.reloadData()
//
//        default:
//            break;
//        }
//
//        ScopeData = SearchData
//        let patientCount = ScopeData.count
//        myPatientsLabel.text = "My Patients (\(patientCount))"
//    }

    
    // MARK: - Refresh Function
    func refreshData(){
        
        let downloadToken = DispatchGroup(); downloadToken.enter();
        
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  { //Signin token & user profile Downloaded now what?
            
            let token = UserDefaults.standard.string(forKey: "token")
            
            let downloadPatients = DispatchGroup(); downloadPatients.enter();
            
            GETPatients().getPatients(token: token!, dispachInstance: downloadPatients)
        
            downloadPatients.notify(queue: DispatchQueue.main) {//got Referrals

                    self.patientData = UserDefaults.standard.value(forKey: "RESTPatients") as! Array<Dictionary<String, String>>
 
                print("refreshData")
                self.patientTable.reloadData()
                let patientCount = self.patientData.count//ScopeData.count
                self.myPatientsLabel.text = "My Patients (\(patientCount))"
                self.refreshControl.endRefreshing()
            }
        }
    }
    

    //
    // #MARK: - Search Functions
    //
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("PLsearch: \(searchText)")
        //let predicate=NSPredicate(format: "SELF.Patient_ID CONTAINS[cd] %@", searchText) // returns .patientName from patientName["patientName"] //"SELF.patientName CONTAINS[cd] %@"
        //let arr=(patientData as NSArray).filtered(using: predicate)
        
        //organization pstatus CarePrograms
        let patientIdPredicate = NSPredicate(format: "SELF.Patient_ID CONTAINS[cd] %@", searchText)
        let patientNamePredicate = NSPredicate(format: "SELF.patientName CONTAINS[cd] %@", searchText)
        let organizationPredicate = NSPredicate(format: "SELF.organization CONTAINS[cd] %@", searchText)
        let careProgramsPredicate = NSPredicate(format: "SELF.CarePrograms CONTAINS[cd] %@", searchText)
        
        let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [patientIdPredicate, patientNamePredicate, organizationPredicate, careProgramsPredicate])
        
        let arr=(/*ScopeData*/ patientData as NSArray).filtered(using: orPredicate)
        
        if arr.count > 0
        {
            SearchData=arr as! Array<Dictionary<String,String>>
        } else {
            SearchData=patientData//ScopeData//
        }
        patientTable.reloadData()
        let patientCount = SearchData.count
        myPatientsLabel.text = "My Patients (\(patientCount))"
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
        
        SearchData=patientData
        patientTable.reloadData()
        
        let patientCount = patientData.count//ScopeData.count
        myPatientsLabel.text = "My Patients (\(patientCount))"
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
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
        cell.caseProgram.text = "Case Program: " + Data["CarePrograms"]! //case program
        
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


