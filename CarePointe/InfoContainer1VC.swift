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
    
    //tables
    @IBOutlet weak var demographicsTable: UITableView!
    @IBOutlet weak var badgeTable: UITableView!
    
    
    @IBOutlet weak var topBages: NSLayoutConstraint! //grow by 50 if first badge chars > 
    @IBOutlet weak var badgeheight: NSLayoutConstraint! //function of bages.count
    
    // class vars
    var patientData:Array<Dictionary<String,String>> = []
    var demographics = [[String]]()
    var patientName = ""
    var patientID = "1982"
    
    //API data
    var restLocations = Array<Dictionary<String,String>>()
    var allBadges = Array<Dictionary<String,String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get demographics from API latest local save
        demographics = UserDefaults.standard.object(forKey: "demographics")! as? [[String]] ?? [[String]]()//saved from PatientListVC
        patientID = demographics[0][1]//"UniqueID"
        
        //getTokenThenBadgeAndCaseFromWebServer()
        
        DispatchQueue.global(qos: .userInitiated).async{//https://www.raywenderlich.com/148513/grand-central-dispatch-tutorial-swift-3-part-1
            DispatchQueue.main.async {//move the work to a background global queue and run the work in the closure asynchronously. This lets viewDidLoad() finish earlier on the main thread and makes the loading feel more snappy.

                self.patientImage.layer.borderWidth = 4
                self.patientImage.layer.borderColor = UIColor.celestialBlue().cgColor
                self.patientImage.layer.cornerRadius = 0.5 * self.patientImage.bounds.size.width
                self.patientImage.clipsToBounds = true
                
                //delegation
                self.demographicsTable.delegate = self
                self.demographicsTable.dataSource = self
                self.badgeTable.delegate = self
                self.badgeTable.dataSource = self
                
                // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
                self.patientName = UserDefaults.standard.string(forKey: "patientName")!
                self.patientNameLabel.text = self.patientName// + "'s Information"
                
                // show patient photo
                let patientPic = UserDefaults.standard.string(forKey: "patientPic")!
                if(patientPic.isEmpty == false){
                    self.patientImage.image = UIImage(named: patientPic)
                }
                
                //Table ROW Height set to auto layout - row height grows with content
                self.demographicsTable.rowHeight = UITableViewAutomaticDimension
                self.demographicsTable.estimatedRowHeight = 150
                
    //            self.demographics = [["UniqueID","P000001"], ["Assigned","Gabe towers"], ["Gender","Female"], 
    //            ["Ethnicity","Hispanic/Latino"], ["SSN#","343-14-3434"], ["DOB","07/10/1947"], ["Primary Language","English"],
    //            ["Email","demo@gmail.com"], ["Intake Notes","Lorem ."], ["Home Address","City Street, Suite 100"], ["City","NY"],
    //            ["Zip","10011"], ["Phone","(816) 679-4482"], ["Cell","(702) 688-9673"], ["Additional Contact","Marie Smith"],
    //            ["Contact Relationship","Sister"], ["Contact Phone","(321) 134-5244"], ["Contact Notes","Lorem ."],
    //            ["Primary Source","Medicaid"], ["Primary Insurance","Humana"], ["Secondary Insurance","none"]
    //            ]
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTokenThenBadgeAndCaseFromWebServer()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("didReceiveMemoryWarning-InfoContainer1VC")
    }
    
            
    //
    // #MARK: - Functions
    //
            
    func getTokenThenBadgeAndCaseFromWebServer() {
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        // 0 get token again -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            //GET Locations(Badge and Case Data)---------------------
            self.getBageandCaseFromLocationsAPI(token:token)
            //-------------------------------------------------------
        }
        
    }
    
    
    func getBageandCaseFromLocationsAPI(token:String) {
        let locationsFlag = DispatchGroup()
        locationsFlag.enter()
        
        let getBadgeAndCaseData = GETLocations()
        getBadgeAndCaseData.getLocations(token: token, patientID: patientID, dispachInstance: locationsFlag)
        
        locationsFlag.notify(queue: DispatchQueue.main) {//locations sent back from cloud
         
            self.allBadges.removeAll()
            
            self.restLocations = UserDefaults.standard.object(forKey: "RESTLocations") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
            
            if self.restLocations.isEmpty == false {
                
                let badges = self.restLocations[0]
                
                if(badges["TransferToFacility"]! != "") {
                    let transArray = self.splitStringToArray(StringIn: badges["TransferToFacility"]!, deliminator:",")
                    for str in transArray {
                        self.allBadges.append(["badgeTitle": str, "color": "green"])
                    }
                    //self.allBadges.append(["badgeTitle":badges["TransferToFacility"]!,"color":"green"])
                }
                if(badges["CarePrograms"]! != "") {
                    
                    let cpArray = self.splitStringToArray(StringIn: badges["CarePrograms"]!, deliminator:",")
                    for str in cpArray {
                        self.allBadges.append(["badgeTitle": str, "color": "green"])
                    }
                    //self.allBadges.append(["badgeTitle":badges["CarePrograms"]!,"color":"green"])
                }
                if(badges["Disease"]! != "") {

                    let diseasesArray = self.splitStringToArray(StringIn:badges["Disease"]!, deliminator:",")
                    for str in diseasesArray {
                        self.allBadges.append(["badgeTitle": str,"color":"gray"])  /*badges["Disease"]!*/
                    }
                }
                
                self.badgeTable.reloadData()
            }
        }
    }

    
    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //badgeTable //demographicsTable
        if tableView == demographicsTable {
            return demographics.count
        } else {
            return allBadges.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        if tableView == demographicsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "demographics") as! InfoDemographicsCell
            
            cell.Label.text = demographics[IndexPath.row][0]
            cell.details.text = demographics[IndexPath.row][1]
            
            if(IndexPath.row % 2 == 0){
                cell.backgroundColor = UIColor.polar()  }
            else{
                cell.backgroundColor = UIColor.white  }
            
            return cell
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "badgecell") as! BadgesCell
            let data = allBadges[IndexPath.row]
            cell.badge.text = data["badgeTitle"]
            
            if(data["color"] == "green"){
                cell.backgroundColor = UIColor.Fern()  }
            else{
                cell.backgroundColor = UIColor.Iron()  }
            
            return cell
        }
        
    }
    
    
    

}
