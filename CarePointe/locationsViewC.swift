//
//  locationsViewC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class locationsViewC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    //table view
    @IBOutlet weak var locationsTable: UITableView!
    @IBOutlet weak var EDVisitTable: UITableView!
    
    //label
    @IBOutlet weak var visitedEDTimesLabel: UILabel!
    
    var locations = [
        [" "," "," "],
        [" "," "," "]
    ]
    var EDTableData:Array<Dictionary<String,String>> = []
    
    
    //API data
    var restLocations = Array<Dictionary<String,String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegation
        locationsTable.delegate = self
        locationsTable.dataSource = self
        EDVisitTable.delegate = self
        EDVisitTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        locationsTable.rowHeight = UITableViewAutomaticDimension
        locationsTable.estimatedRowHeight = 75
        EDVisitTable.rowHeight = UITableViewAutomaticDimension
        EDVisitTable.estimatedRowHeight = 75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        restLocations = UserDefaults.standard.object(forKey: "RESTLocations") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
        
        if restLocations.isEmpty == false {
        
            locations.removeAll()
            
            for arrayCase in restLocations {
                
                let admitDate = convertDateStringToDate(longDate: arrayCase["AdmittanceDate"]!)
                
                locations.append([arrayCase["TransferToFacility"]!,arrayCase["TransferFromFacility"]!,admitDate])
            }
            
            
            //let admitDate = convertDateStringToDate(longDate: caseData["AdmittanceDate"]!)
            getEDVisits()
            
            locationsTable.reloadData()

        }
    }
    

    //2 return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == locationsTable {
            return locations.count
        } else {
            return EDTableData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == locationsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationscell", for: indexPath) as! locationsCell
            
            cell.label.text = locations[indexPath.row][0]
            cell.details.text = locations[indexPath.row][1]
            cell.details2.text = locations[indexPath.row][2]
            
            if(indexPath.row % 2 == 0){
                cell.backgroundColor = UIColor.polar()  }
            else{
                cell.backgroundColor = UIColor.white  }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "edcell", for: indexPath) as! edcell
            
            let data = EDTableData[indexPath.row]
            cell.facility.text = data["Facility_name"]
            cell.date.text = data["AdmittanceDate"]
            cell.chiefComplaint.text = data["ChiefComplaint"]
            
            if(indexPath.row % 2 == 0){
                cell.backgroundColor = UIColor.polar()  }
            else{
                cell.backgroundColor = UIColor.white  }
            
            return cell
        }
    }
}

// MARK: - Private Methods
private extension locationsViewC{
    
    func getEDVisits(){
        
        var userEditedCount = false
        
        let downloadToken = DispatchGroup(); downloadToken.enter()
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            let demographics = UserDefaults.standard.object(forKey: "demographics")! as? [[String]] ?? [[String]]()//saved from PatientListVC
            let patientID = demographics[0][1]//"UniqueID"
            
            let downloadEDCount = DispatchGroup(); downloadEDCount.enter()
            GETEDCount().getVisitsCount(token: token, patientID: patientID, dispachInstance: downloadEDCount)
            
            let downloadED = DispatchGroup(); downloadED.enter()
            GETED().getVisits(token: token, patientID: patientID, dispachInstance: downloadED)
            
            downloadEDCount.notify(queue: DispatchQueue.main)  {//got COUNT dict
                
                let restEDCount = UserDefaults.standard.edVisitsCount()
                
                if (restEDCount.isEmpty == false){//COUNT dict is NOT empty
                    
                    userEditedCount = true
                    
                    let dict = restEDCount[0]
                    let EDCount = Int(dict["VisitCount"]!)
                    var times = " times"
                    if (EDCount! < 2) { times = " time"}
                    
                    let fromDate = self.convertDateStringToDate(longDate: dict["VisitedFrom"]!)
                    let toDate = self.convertDateStringToDate(longDate: dict["VisitedTo"]!)
                    
                    self.visitedEDTimesLabel.text = "Visited ED " + dict["VisitCount"]! + times + " between "
                        + fromDate + " and " + toDate
                }
             
            }
            
            downloadED.notify(queue: DispatchQueue.main)  {
                
                self.EDTableData = UserDefaults.standard.edVisits()

                let visitCount = self.EDTableData.count
                
                if (self.EDTableData.isEmpty == false && userEditedCount == false) {

                    self.EDTableData.sort { $0["AdmittanceDate"]! < $1["AdmittanceDate"]! }//sort arry in place
                    
                    for index in 0..<visitCount{
                        let longDate = self.EDTableData[index]["AdmittanceDate"]
                        let shortDate = self.convertDateStringToDate(longDate: longDate!)
                        self.EDTableData[index]["AdmittanceDate"] = shortDate
                    }
                    
                    self.EDVisitTable.reloadData()
                    
                    var times = ""
                    if (visitCount == 1) { times = " time on \(self.EDTableData[0]["AdmittanceDate"]!)"  }
                    if (visitCount > 1) { times = " times between \(self.EDTableData[0]["AdmittanceDate"]!) and \(self.EDTableData[visitCount-1]["AdmittanceDate"]!)" }
                    
                    self.visitedEDTimesLabel.text = "Visited ED \(visitCount) " + times
                    
                }
            }


        }
    }
    

}
