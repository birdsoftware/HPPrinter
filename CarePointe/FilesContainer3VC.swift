//
//  FilesContainer3VC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/8/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class FilesContainer3VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //tables
    @IBOutlet weak var filesTable: UITableView!
    @IBOutlet weak var formTable: UITableView!
    
    //labels
    @IBOutlet weak var documentTitleLabel: UILabel!
    @IBOutlet weak var formTitleLabel: UILabel!
    
    var demographics = [[String]]()
    var patientID = "1982"
    
    var files = [[String]]()
    var forms = Array<Dictionary<String,String>>()
    
    //API data
    var restDocs = Array<Dictionary<String,String>>()
    var activeEpisodeID = ""
    
    //PULL TO REFRESH CONTROL
    let refreshControl = UIRefreshControl()
    let refreshControlForm = UIRefreshControl()
    var isPullDocsRefresh = false
    var isPullFormsRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get demographics from API latest local save
        demographics = UserDefaults.standard.object(forKey: "demographics")! as? [[String]] ?? [[String]]()//saved from PatientListVC
        patientID = demographics[0][1]//"UniqueID"
        
        //delegation
        filesTable.delegate = self
        filesTable.dataSource = self
        formTable.delegate = self
        formTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        filesTable.rowHeight = UITableViewAutomaticDimension
        filesTable.estimatedRowHeight = 100
        formTable.rowHeight = UITableViewAutomaticDimension
        formTable.estimatedRowHeight = 100
        
        linkPullRefreshAssets()
        
        //files = [["file name","category","episode","filepath","CreatedDateTime"]//self.patientID+"/episode_"+dict["Episode_ID"]!+"/"+dict["FilePath"]!]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isKeyPresentInUserDefaults(key: "RESTForms") {
            forms = UserDefaults.standard.object(forKey: "RESTForms")! as! Array<Dictionary<String, String>>
        }
        getDocumentsAndFormFromWebServer(getDocuemnt: true, getForm: true)
        
    }
    
    //
    // MARK: - Functions
    //
    func getDocumentsAndFormFromWebServer(getDocuemnt:Bool, getForm: Bool){
        let downloadToken = DispatchGroup(); downloadToken.enter()
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            let token = UserDefaults.standard.string(forKey: "token")!
            
            if getForm {
                let caseFlag = DispatchGroup(); caseFlag.enter();
                GETCase().getNTUCString(token: token, patientID: self.patientID, dispachInstance: caseFlag)
                
                caseFlag.notify(queue: DispatchQueue.main) {//GET EpisodeID that is Active--------------------
                    let ntuc = UserDefaults.standard.ntuc()
                    let ntucDict = ntuc[0]
                    self.activeEpisodeID = ntucDict["Episode_ID"]!
                    
                    //GET FORM
                    let formFlag = DispatchGroup(); formFlag.enter()
                    GETForm().getFormByEpisode(token: token, episodeID: self.activeEpisodeID, dispachInstance: formFlag)
                    formFlag.notify(queue: DispatchQueue.main){
                        self.forms = UserDefaults.standard.object(forKey: "RESTForms")! as! Array<Dictionary<String, String>>
                        self.formTable.reloadData()
                        self.updateTableTitles()
                        if self.isPullFormsRefresh {
                            self.refreshControlForm.endRefreshing()
                            self.isPullFormsRefresh = false
                        }
                    }
                }
            }
            
            if getDocuemnt {
                let docsFlag = DispatchGroup(); docsFlag.enter()
                GETDocuments().getDocs(token: token, patientID: self.patientID, dispachInstance: docsFlag)
                
                docsFlag.notify(queue: DispatchQueue.main) {//docs sent back from cloud
                    self.restDocs = UserDefaults.standard.object(forKey: "RESTDocuments") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
                    
                    if self.restDocs.isEmpty == false {
                        self.files.removeAll()
                        for dict in self.restDocs {
                            self.files.append([dict["DocumentName"]!,dict["DocumentCategory"]!, dict["Episode_ID"]!,dict["FilePath"]!,dict["CreatedDateTime"]!])
                        }
                        self.filesTable.reloadData()
                        self.updateTableTitles()
                        if self.isPullDocsRefresh {
                            self.refreshControl.endRefreshing()
                            self.isPullDocsRefresh = false
                        }
                    }
                }
            }
        }
    }
    
    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == filesTable {  return files.count }
        else  {  return forms.count }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        if tableView == filesTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "files") as! filesCell
            
            cell.label.text = files[IndexPath.row][0]   //File Name
            cell.details.text = files[IndexPath.row][1] //Category
            //if(IndexPath.row % 2 == 0) { cell.backgroundColor = UIColor.polar()  }
            //else { cell.backgroundColor = UIColor.white  }
            cell.backgroundColor = alternateCellColor(row: IndexPath.row)
            cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "formcell") as! formsCell
            
            let data = forms[IndexPath.row]
            cell.form.text = data["assessment_name"]
            cell.type.text = data["assessment_type"]
            let shortDate:String = convertDateStringToDate(longDate: data["task_date"]!)
            cell.date.text = shortDate
            cell.backgroundColor = alternateCellColor(row: IndexPath.row)
            cell.accessoryType = .disclosureIndicator // add arrow > to cell
            
            return cell
        }
        
    }
    
    //
    // #MARK: - Segue
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segeuFormToDocWebView"{
            let formIndex = formTable.indexPathForSelectedRow?.row
            let selectedForm = forms[formIndex!]
            
            let DocumentName        = selectedForm["assessment_name"]
            let DocumentCategory    = selectedForm["assessment_type"]
            let Episode_ID          = activeEpisodeID
            let FilePath            = DocumentName! + "_" + Episode_ID + ".pdf"
            let CreatedDateTime     = selectedForm["task_date"]
            let justDate            = convertDateStringToDate(longDate: CreatedDateTime!)
            
            let urlwithPercentEscapes = FilePath.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            let webDocLoc = "https://carepointe.cloud/episode_document/patient_"+patientID+"/episode_"+Episode_ID+"/"+urlwithPercentEscapes!//FilePath
            
            if let toViewController = segue.destination as? DocWebVC {
                toViewController.segueDocumentFullFilePath = webDocLoc
                toViewController.segueDocumentName = DocumentName
                toViewController.segueDocumentCategory = DocumentCategory
                toViewController.segueDocumentCreationDateTime = justDate
            }
            
        }//https://carepointe.cloud/episode_document/patient_117551/episode_3312/Initial%20Call%20-%20Form_3312.pdf FILE TYPE
        //https://carepointe.cloud/episode_document/patient_117236/episode_2735/CSA%20Fillable%20File_2735.pdf File type
        //https://carepointe.cloud/episode_document/patient_117236/episode_2735/Complex%20Case%20Managment%20Report_2735.pdf Dynamic
        
        if segue.identifier == "segeuToDocWebView" {
            
            let filesIndex = filesTable.indexPathForSelectedRow?.row //<-SEGUE segue majic
            
            let DocumentName        = files[filesIndex!][0]
            let DocumentCategory    = files[filesIndex!][1]
            let Episode_ID          = files[filesIndex!][2]
            let FilePath            = files[filesIndex!][3]
            let CreatedDateTime     = files[filesIndex!][4]
            let justDate            = convertDateStringToDate(longDate: CreatedDateTime)
            
            let urlwithPercentEscapes = FilePath.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            let webDocLoc = "https://carepointe.cloud/episode_document/patient_"+patientID+"/episode_"+Episode_ID+"/"+urlwithPercentEscapes!//FilePath
            
            if let toViewController = segue.destination as? DocWebVC {
                toViewController.segueDocumentFullFilePath = webDocLoc
                toViewController.segueDocumentName = DocumentName
                toViewController.segueDocumentCategory = DocumentCategory
                toViewController.segueDocumentCreationDateTime = justDate
            }
        }            //https://carepointe.cloud/episode_document/patient_1848/episode_1821/Monica_170503011511.pdf
    }
}

private extension FilesContainer3VC {
    // #MARK - private functions formTitleLabel
    func updateTableTitles(){
        var titleString:String = ""
        if (files.count == 1) { titleString += "1 Document" }
        else { titleString += "\(files.count) Documents" }
        documentTitleLabel.text = titleString
        titleString = ""
        if (forms.count == 1) {titleString += "1 Completed Form"}
        else { titleString += "\(forms.count) Completed Forms" }
        formTitleLabel.text = titleString
    }
    
    func alternateCellColor(row: Int) -> UIColor {
        if(row % 2 == 0) { return UIColor.polar()  }
        else { return UIColor.white  }
    }
}

extension FilesContainer3VC {
    // #MARK - PULL TO REFRESH TABLES FUNCTIONS
    
    func linkPullRefreshAssets(){
        
        filesTable.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(FilesContainer3VC.refreshFileData), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Documents ...")
        
        formTable.refreshControl = refreshControlForm
        refreshControlForm.addTarget(self, action: #selector(FilesContainer3VC.refreshFormData), for: UIControlEvents.valueChanged)
        refreshControlForm.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControlForm.attributedTitle = NSAttributedString(string: "Fetching Forms ...")
    }
    
    func refreshFileData(){
        getDocumentsAndFormFromWebServer(getDocuemnt: true, getForm: false)
        isPullDocsRefresh = true
    }
    
    func refreshFormData(){
        getDocumentsAndFormFromWebServer(getDocuemnt: false, getForm: true)
        isPullFormsRefresh = true
    }
}

