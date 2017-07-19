//
//  EMRViewC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class EMRViewC: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {

    @IBOutlet weak var emrTable: UITableView!
    @IBOutlet weak var noEncountersAlertLabel: UILabel!
    
    var emrTitles = [["No Encounters for this patient","","",""]]
    
    var encounterArray:[Encounter] = []
    var parser = XMLParser()
//    var selectedViewSummaryFromTable = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noEncountersAlertLabel.isHidden = true
        
        //delegation
        emrTable.dataSource = self
        emrTable.delegate = self
        
        let demographics =
            UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//saved from PatientListVC
        let patientID = demographics[0][1]//"UniqueID" 8
        let myUrl = NSURL(string: "http://carepointe.cloud/EHR_XML_Carepointe/EL_Human_" + patientID + ".xml")
        
        self.parser = XMLParser(contentsOf: myUrl! as URL)!
        self.parser.delegate = self
        let success:Bool = self.parser.parse()
        if success {
            print("success")
            emrTitles.removeAll()
            for encounter in encounterArray {
                let encounterSignedOff = returnBoolWord(firstLetterBool: encounter.Is_Encounter_Signed_OFF)
                emrTitles.append(["\(encounter.Provider_Name) | \(encounter.Facility_Name) | Signed Off? \(encounterSignedOff)","\(encounter.Date_of_Service)","\(encounter.View_Summary)","\(encounter.Encounter_ID)"])
            }
            emrTable.reloadData()
            
        } else {
            print("parse failure!")
            noEncountersAlertLabel.isHidden = false
            emrTitles.removeAll()
            emrTable.reloadData()
        }
    }
    func returnBoolWord(firstLetterBool: String)->String{
        if firstLetterBool == "Y" {return "Yes"}
        else {return "No"}
    }
    
    //
    // #MARK: - Table View
    //
    
    //[2] RETURN number of ROWS in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emrTitles.count
    }
    
    //[3] RETURN actual CELL to be displayed
    // SHOW SEGUE ->
    // " 1. click cell drag to second view. select the “show” segue in the “Selection Segue” section. "
    //http://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "emrupdatecell") as! EMRUpdateCell
        
        cell.EMRTitle.text = emrTitles[IndexPath.row][0]
        cell.date.text = emrTitles[IndexPath.row][1]
        cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //iew_Summary="Encounter_5.xml"
//            selectedViewSummaryFromTable = emrTitles[indexPath.row][2]
//        print("\(selectedViewSummaryFromTable)")
//    }
    
    //
    // #MARK - parser functions
    //
    
    //called whenever a new element <house> found
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "Encounter" {
            
            let encounter = Encounter()
            
            for string in attributeDict {
                switch  string.key {
                case "Encounter_ID":
                    encounter.Encounter_ID = string.value
                    break
                case "Facility_Name":
                    encounter.Facility_Name = string.value
                    break
                case "Date_of_Service":
                    encounter.Date_of_Service = string.value
                    break
                case "Encounter_Provider_ID":
                    encounter.Encounter_Provider_ID = string.value
                    break
                case "Is_Encounter_Signed_OFF":
                    encounter.Is_Encounter_Signed_OFF = string.value
                    break
                case "Provider_Name":
                    encounter.Provider_Name = string.value
                    break
                case "View_Summary":
                    encounter.View_Summary = string.value
                    break
                case "Edit_Capella_Carepointe_URL":
                    encounter.Edit_Capella_Carepointe_URL = string.value
                    break
                default:
                    break
                }
            }
            encounterArray.append(encounter)
            
        } else {
            print("NO ELEMENT FOUND: \(elementName)")
        }
        
        
    }
    //called whenever any element is closed </house>
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("didEndElement")
    }
    //called whenever any characters found between 2 tags
    func parser(_ parser: XMLParser, foundCharacters string: String) {
    }
    //called when error
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }


    //
    // MARK: - Navigation
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let selectedRow = ((emrTable.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
        
        if let vc = segue.destination as? SingleEMRViewController {
            
            vc.segueViewSummary = emrTitles[selectedRow][2]
            vc.segueEncounterID = emrTitles[selectedRow][3]
        }
        
    }
    

}
