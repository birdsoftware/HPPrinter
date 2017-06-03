//
//  Contain4RxFilesVC.swift
//  CarePointe
//
//  Created by Brian Bird on 5/19/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class Contain4RxFilesVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    //table
    @IBOutlet weak var rxFilesTable: UITableView!
    
    
    var demographics = [[String]]()
    var patientID = "1982"
    
    var files = [[String]]()
    
    //API data
    var restDocs = Array<Dictionary<String,String>>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get demographics from API latest local save
        demographics = UserDefaults.standard.object(forKey: "demographics")! as? [[String]] ?? [[String]]()//saved from PatientListVC
        patientID = demographics[0][1]//"UniqueID"

        //delegation
        rxFilesTable.delegate = self
        rxFilesTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        rxFilesTable.rowHeight = UITableViewAutomaticDimension
        rxFilesTable.estimatedRowHeight = 150
        
        files = [["file name","category","episode","filepath","CreatedDateTime"]//self.patientID+"/episode_"+dict["Episode_ID"]!+"/"+dict["FilePath"]!
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTokenThenDocumentsFromWebServer()
        
    }
    
    //
    // MARK: - Functions
    //
    
    func getTokenThenDocumentsFromWebServer(){
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        // 0 get token again -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            //GET Docs---------------------
            self.getDocsFromDocumentsAPI(token:token)
            //-------------------------------------------------------
        }
    }
    
    func getDocsFromDocumentsAPI(token:String) {
        
        let docsFlag = DispatchGroup()
        docsFlag.enter()
        //let pid = patientID
        let newDocAPI = GETDocuments()
        newDocAPI.getDocs(token: token, patientID: patientID, dispachInstance: docsFlag)
        
        docsFlag.notify(queue: DispatchQueue.main) {//docs sent back from cloud
            //get docs and category and update filesTable-------------------
            self.restDocs = UserDefaults.standard.object(forKey: "RESTDocuments") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
            
            if self.restDocs.isEmpty == false {
                
                self.files.removeAll()
                
                for dict in self.restDocs {
                    
                    self.files.append([dict["DocumentName"]!,dict["DocumentCategory"]!, dict["Episode_ID"]!,dict["FilePath"]!,dict["CreatedDateTime"]!])
                }
                self.rxFilesTable.reloadData()
            }
            //-----------------------------
        }
    }
    
    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "files") as! filesCell
        
        cell.label.text = files[IndexPath.row][0]   //File Name
        cell.details.text = files[IndexPath.row][1] //Category
        if(IndexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.polar()  }
        else{
            cell.backgroundColor = UIColor.white  }
        cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
        return cell
    }
    
    
    //
    // #MARK: - Segue
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segeuToDocWebViewFromRxView" {
            
            let filesIndex = rxFilesTable.indexPathForSelectedRow?.row //<-SEGUE segue majic
            
            let DocumentName        = files[filesIndex!][0]
            let DocumentCategory    = files[filesIndex!][1]
            let Episode_ID          = files[filesIndex!][2]
            let FilePath            = files[filesIndex!][3]
            let CreatedDateTime     = files[filesIndex!][4]
            let justDate            = convertDateStringToDate(longDate: CreatedDateTime)
            
            let webDocLoc = "https://carepointe.cloud/episode_document/patient_"+patientID+"/episode_"+Episode_ID+"/"+FilePath
            
            if let toViewController = segue.destination as? DocWebVC {
                toViewController.segueDocumentFullFilePath = webDocLoc
                toViewController.segueDocumentName = DocumentName
                toViewController.segueDocumentCategory = DocumentCategory
                toViewController.segueDocumentCreationDateTime = justDate
            }
        }            //https://carepointe.cloud/episode_document/patient_1848/episode_1821/Monica_170503011511.pdf
    }
    

}
