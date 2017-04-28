//
//  InfoContainer1VC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/8/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class InfoContainer1VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientImage: UIImageView!
    //@IBOutlet weak var badgeLabel: UILabel!
    //@IBOutlet weak var badgeLabel2: UILabel!
    
    //table
    @IBOutlet weak var demographicsTable: UITableView!
    
    // class vars
    var patientData:Array<Dictionary<String,String>> = []
    var demographics = [[String]]()
    var patientName = ""
    
    //From Patients table segue
//    var isFromPatients = false
//    var segueUniqueID: String!
//    var segueAssigned: String!
//    var segueGender: String!
//    var segueEthnicity:String!
//    var segueSSN:String!
//    var segueDOB:String!
//    var seguePrimaryLanguage:String!
//    var segueEmail:String!
//    var segueIntakeNotes:String!
//    var segueHomeAddress:String!
//    var segueCity:String!
//    var segueZip:String!
//    var seguePhone:String!
//    var segueCell:String!
//    var segueAdditionalContact:String!
//    var segueContactRelationship:String!
//    var segueContactPhone:String!
//    var segueContactNotes:String!
//    var seguePrimarySource:String!
//    var seguePrimaryInsurance:String!
//    var segueSecondaryInsurance:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async {                        //https://www.raywenderlich.com/148513/grand-central-dispatch-tutorial-swift-3-part-1
        DispatchQueue.main.async {//move the work to a background global queue and run the work in the closure asynchronously. This lets viewDidLoad() finish earlier on the main thread and makes the loading feel more snappy.
            //careTeam button round button
            //self.careTeamButton.layer.cornerRadius = 0.5 * self.careTeamButton.bounds.size.width
            //self.careTeamButton.clipsToBounds = true
            self.patientImage.layer.borderWidth = 4
            self.patientImage.layer.borderColor = UIColor.celestialBlue().cgColor
            self.patientImage.layer.cornerRadius = 0.5 * self.patientImage.bounds.size.width
            self.patientImage.clipsToBounds = true
            
            //delegation
            self.demographicsTable.delegate = self
            self.demographicsTable.dataSource = self
            
            // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
            self.patientName = UserDefaults.standard.string(forKey: "patientName")!
            self.patientNameLabel.text = self.patientName// + "'s Information"
            
            // show patient photo
            let patientPic = UserDefaults.standard.string(forKey: "patientPic")!
            if(patientPic.isEmpty == false){
                self.patientImage.image = UIImage(named: patientPic)
                
            }
            
            //get demographics from API latest local save
            let latestDemo = UserDefaults.standard.object(forKey: "demographics")! //saved from PatientListVC
            self.demographics = latestDemo as! [[String]]
            
            //Table ROW Height set to auto layout - row height grows with content
            self.demographicsTable.rowHeight = UITableViewAutomaticDimension
            self.demographicsTable.estimatedRowHeight = 150
            
            
//            self.demographics = [["UniqueID","P000001"],   //TODO: get from Patients API? or segue info from patients table view
//                                ["Assigned","Gabe towers"],
//                                ["Gender","Female"],
//                                ["Ethnicity","Hispanic/Latino"],
//                                ["SSN#","343-14-3434"],
//                                ["DOB","07/10/1947"],
//                                ["Primary Language","English"],
//                                ["Email","demo@gmail.com"],
//                                ["Intake Notes","Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut turpis odio, porta a erat ac, porttitor lacinia elit. Fusce molestie scelerisque urna, non ullamcorper erat condimentum at. Vivamus id nisl dui. Nam egestas justo ut metus dapibus, at placerat mauris ullamcorper. Donec aliquam metus ligula. Maecenas dui lectus, tempor eu faucibus nec, tincidunt non sapien. Pellentesque pellentesque, eros eget feugiat elementum, ante orci rhoncus felis, congue pulvinar sem lorem id elit. Donec placerat vitae neque sed volutpat."],
//                                ["Home Address","City Street, Suite 100"],
//                                ["City","NY"],
//                                ["Zip","10011"],
//                                ["Phone","(816) 679-4482"],
//                                ["Cell","(702) 688-9673"],
//                                ["Additional Contact","Marie Smith"],
//                                ["Contact Relationship","Sister"],
//                                ["Contact Phone","(321) 134-5244"],
//                                ["Contact Notes","Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut turpis odio, porta a erat ac, porttitor lacinia elit. Fusce molestie scelerisque urna, non ullamcorper erat condimentum at. Vivamus id nisl dui. Nam egestas justo ut metus dapibus, at placerat mauris ullamcorper. Donec aliquam metus ligula. Maecenas dui lectus, tempor eu faucibus nec, tincidunt non sapien. Pellentesque pellentesque."],
//                                ["Primary Source","Medicaid"],
//                                ["Primary Insurance","Humana"],
//                                ["Secondary Insurance","none"]
//            ]
            }}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("didReceiveMemoryWarning-InfoContainer1VC")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        //let patientData = UserDefaults.standard.object(forKey: "RESTPatientsPatientIDs") as? [[String]] ?? [[String]]()
//        // get userData for communication drop down list
//        if isKeyPresentInUserDefaults(key: "RESTPatients"){//""userData"){
//            patientData = UserDefaults.standard.value(forKey: "RESTPatients") as! Array<Dictionary<String, String>>//"userData") as! Array<Dictionary<String, String>>
//        }
//        
//        demographicsTable.reloadData()
//    }
    

    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return demographics.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "demographics") as! InfoDemographicsCell
        
        cell.Label.text = demographics[IndexPath.row][0]
        cell.details.text = demographics[IndexPath.row][1]
        
        if(IndexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.polar()  }
        else{
            cell.backgroundColor = UIColor.white  }
        
        return cell
    }
    

}
