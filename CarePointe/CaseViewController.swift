//
//  CaseViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class CaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //segment controller
    @IBOutlet weak var caseSegmentControl: UISegmentedControl!
    
    //containers
    @IBOutlet weak var containerView1: UIView! //services
    @IBOutlet weak var containerView2: UIView! //locations
    
    //tabels
    @IBOutlet weak var caseTable: UITableView!
    @IBOutlet weak var clinicalTable: UITableView!
    
    var caseInfo = [["Start Date", "-"],//"02/02/2017"],
                    ["NTUC","-"],
                    ["NTUC notes", "-"],
                   ["Program", "-"],//"Transitional Care"],
                   ["Acuity","-"],//"High"],
                   ["SNP","-"],//"Caregiver, Supplies, Transportation"],
                   ["Summary","-"],//"Patient came to us from Observation Unit..."]
                   ]
    
    var clinicalData = [["ICD-10's","-"],//"Dependence on Wheelchair"],
                        ["Symptoms","-"],
                        ["Disease", "-"],
                        ]
    
    //API data
    var restLocations = Array<Dictionary<String,String>>()
    var diseases = Array<Dictionary<String,String>>()
    //var ntuc = Array<Dictionary<String,String>>()
    //var episodeNotes = Array<Dictionary<String,String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up UI
        containerView1.isHidden = true
        containerView2.isHidden = true
        
        //delegation
        caseTable.dataSource = self
        caseTable.delegate = self
        clinicalTable.dataSource = self
        clinicalTable.delegate = self
        
        caseTable.rowHeight = UITableViewAutomaticDimension
        caseTable.estimatedRowHeight = 150
        clinicalTable.rowHeight = UITableViewAutomaticDimension
        clinicalTable.estimatedRowHeight = 150
        
        // Setup sement control font and font size
        let attr = NSDictionary(object: UIFont(name: "Futura", size: 16.0)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        restLocations = UserDefaults.standard.object(forKey: "RESTLocations") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
        
        if (restLocations.isEmpty == false) {
            
            let caseData = restLocations[0]
            var episodeid = ""
            episodeid = caseData["Episode_ID"] ?? ""
            print("episodeid \(episodeid)")
            
            
            let admitDate = convertDateStringToDate(longDate: caseData["CreatedDateTime"]!)//AdmittanceDate
            
            caseInfo[0] = ["Start Date", admitDate]//
            //            ["NTUC",ntucDict["ntuc"]!],
            //            ["NTUC notes", "-"],
            caseInfo[3] = ["Program", caseData["CarePrograms"]!]//"Transitional Care"]
            caseInfo[4] = ["Acuity",caseData["ComplexityLevel"]!]//"High"],
            caseInfo[5] = ["SNP", caseData["Disease"]!]//"Caregiver, Supplies, Transportation"],
            caseInfo[6] = ["Summary", caseData["EpisodeSummary"]!]//"Patient came to us from Observation Unit at Chandler Regional Hospital. Patient had a few prior hospitalizations due to falls in the past weeks. Patient suffers from permanent brain damage due to traumatic car accident. Experiences access falls and confusion and needs 24hr monitoring. Lives with Husband and Daughter that act as caregivers."]
            
            
            clinicalData[0] = ["ICD-10's", caseData["ICD_9s"]!]//"Dependence on Wheelchair"],
            clinicalData[1] = ["Symptoms", caseData["Diagnosis"]!]
            
            //self.clinicalData[2] = ["Disease", stringDisease]
            //clinicalData = [["ICD-10's", caseData["ICD_9s"]!],//"Dependence on Wheelchair"],
            //                    ["Symptoms", caseData["Diagnosis"]!],
            //                    ["Disease", ""]//caseData["Disease"]!]
            //]
            
            signInThenGetDeseaseData(episode: episodeid)//update table disease_name, complexity
            caseTable.reloadData()
            clinicalTable.reloadData()
        }
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
    
    @IBAction func feedsSegmentControllerTapped(_ sender: Any) {
    
        switch caseSegmentControl.selectedSegmentIndex
        {
        case 0:
            containerView1.isHidden = true
            containerView2.isHidden = true
        case 1:
            containerView1.isHidden = false
            containerView2.isHidden = true
        case 2:
            containerView1.isHidden = true
            containerView2.isHidden = false
        default:
            break;
        }
    }
    
    //
    // #MARK: - Functions
    //
    func signInThenGetDeseaseData(episode: String)//update table disease_name, complexity
    {
        
        let downloadToken = DispatchGroup(); downloadToken.enter()
        
        // 0 get token again -----------
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!

            //get demographics from API latest local save
            let demographics = UserDefaults.standard.object(forKey: "demographics")! as? [[String]] ?? [[String]]()//saved from PatientListVC
            let patientID = demographics[0][1]//"UniqueID"
            
            //GET DISEASEs---------------------
            self.getDiseaseFromWebServer(token: token, episode: episode)//update table disease_name, complexity
            
            //GET ntuc Case--------------------
            let caseFlag = DispatchGroup(); caseFlag.enter();
            GETCase().getNTUCString(token: token, patientID: patientID, dispachInstance: caseFlag)
            
            caseFlag.notify(queue: DispatchQueue.main) {
                let ntuc = UserDefaults.standard.ntuc()

                if (ntuc.isEmpty == false) {
                    let ntucDict = ntuc[0]
                    self.caseInfo[1] = ["NTUC",ntucDict["ntuc"]!]
                    
                    let activeEpisodeID = ntucDict["Episode_ID"]
                    let episodeNoteFlag = DispatchGroup(); episodeNoteFlag.enter();
                    GETEpisode().getEpisodeNotes(token: token, episodeID: activeEpisodeID!, dispachInstance: episodeNoteFlag)
                    
                    episodeNoteFlag.notify(queue: DispatchQueue.main) {
                        
                        let episodeNotes = UserDefaults.standard.episodeNotes()
                        
                        if (episodeNotes.isEmpty == false) {
                            let enDict = episodeNotes[0]
                            self.caseInfo[2] = ["NTUC notes", enDict["episode_notes"]!]
                    
                            self.caseTable.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func getDiseaseFromWebServer(token: String, episode: String)//update table disease_name, complexity
    {
        
        let diseaseFlag = DispatchGroup()
        diseaseFlag.enter()
        
        let diseaseLoad = GETDisease()
        diseaseLoad.getDisease(token: token, episodeID: episode, dispachInstance: diseaseFlag)
        
        diseaseFlag.notify(queue: DispatchQueue.main) {//finished downloading disease now do what
            
            self.diseases = UserDefaults.standard.object(forKey: "RESTDisease") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
            
            var stringDisease = ""
            var isFirst = true
            
            for disease in self.diseases {
                
                if (!isFirst) {
                    stringDisease += " | "
                } else { isFirst = false }
                
                 stringDisease += disease["disease_name"]! + ", Complexity: " + disease["complexity"]!
            }
            
            self.clinicalData[2] = ["Disease", stringDisease]
            
            self.clinicalTable.reloadData()
        }
        
    }
    
    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == caseTable){
            
            if(caseInfo.isEmpty == false) { return caseInfo.count } else { return 0 }
            
        } else {
            if(clinicalData.isEmpty == false) { return clinicalData.count } else { return 0 }
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == caseTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "casecell") as! caseCell
            
            cell.label.text = caseInfo[IndexPath.row][0]
            cell.details.text = caseInfo[IndexPath.row][1]
            
            if(IndexPath.row % 2 == 0){
                cell.backgroundColor = UIColor.polar()  }
            else{
                cell.backgroundColor = UIColor.white  }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "clinicalcell") as! clinicalCell
            
            cell.label.text = clinicalData[IndexPath.row][0]
            cell.details.text = clinicalData[IndexPath.row][1]
            
            if(IndexPath.row % 2 == 0){
                cell.backgroundColor = UIColor.polar()  }
            else{
                cell.backgroundColor = UIColor.white  }
            
            return cell
        }
        
        
        
        
    }

    
    
}
