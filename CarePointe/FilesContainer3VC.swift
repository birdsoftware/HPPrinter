//
//  FilesContainer3VC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/8/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class FilesContainer3VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filesTable: UITableView!
   
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
        filesTable.delegate = self
        filesTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        filesTable.rowHeight = UITableViewAutomaticDimension
        filesTable.estimatedRowHeight = 150
        
        files = [["file name","-"],
                  ["file name","-"]
        ]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTokenThenDocumentsFromWebServer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let newDocAPI = GETDocuments()
        newDocAPI.getDocs(token: token, patientID: patientID, dispachInstance: docsFlag)
        
        docsFlag.notify(queue: DispatchQueue.main) {//docs sent back from cloud
        
            //get docs and category and update filesTable-------------------
            self.restDocs = UserDefaults.standard.object(forKey: "RESTDocuments") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
            
            if self.restDocs.isEmpty == false {
                
                self.files.removeAll()
                
                for dict in self.restDocs {
                    
                    //let fileDate = convertDateStringToDate(longDate: arrayCase["CreatedDateTime"]!) // "FilePath"
                    //if
                    
                    self.files.append([dict["DocumentName"]!,dict["DocumentCategory"]!])
                }
                
                self.filesTable.reloadData()
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
        
        cell.label.text = files[IndexPath.row][0]
        cell.details.text = files[IndexPath.row][1]
        
        if(IndexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.polar()  }
        else{
            cell.backgroundColor = UIColor.white  }
        
        cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
        return cell
    }
    

}
