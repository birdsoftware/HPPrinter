//
//  PTVTableViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/30/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PTVTableViewController: UITableViewController {

    @IBOutlet var PTVTableViewController: UITableView!
    
    var referrals = Array<Dictionary<String,String>>()
    var pendingReferrals = Array<Dictionary<String,String>>()
    var scheduledReferrals = Array<Dictionary<String,String>>()
    var completeReferrals = Array<Dictionary<String,String>>()
    
    var numberNewPatients = 0
    var numberScheduledPatients = 0
    var numberCompletePatiets = 0
    
    let section = ["Pending", "Scheduled", "Complete"]
    var whatAppointmentStatusButtonTapped = "Complete"


    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

                //getUpdateAppointmentData()
     
        //TODO: fix this is crashes in build 12
                //appPatImage = UserDefaults.standard.object(forKey: "appPatImage") as! [[String]]
    }

//    func isKeyPresentInUserDefaults(key: String) -> Bool {
//        return UserDefaults.standard.object(forKey: key) != nil
//    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isKeyPresentInUserDefaults(key: "whatAppointmentStatusButtonTapped"){
            whatAppointmentStatusButtonTapped = UserDefaults.standard.string(forKey: "whatAppointmentStatusButtonTapped")! 
        }
        
        if isKeyPresentInUserDefaults(key: "RESTAllReferrals"){
            referrals = UserDefaults.standard.value(forKey: "RESTAllReferrals") as! Array<Dictionary<String,String>>//Pending or Scheduled or Complete
            
            // PLACE REFERRALS INTO ARRAYS BY STATUS
            for referral in referrals {
                
                switch referral["Status"]! //from tbl_care_plan
                {
                case "Complete", "Rejected/Inactive", "Cancelled":
                    numberCompletePatiets += 1
                    completeReferrals.append(referral)
                    
                case "Scheduled", "In Service":
                    numberScheduledPatients += 1
                    scheduledReferrals.append(referral)
                    
                case "Pending", "Opened":
                    numberNewPatients += 1
                    pendingReferrals.append(referral)
                    
                default:
                    break
                } //Others:"Not Taken Under Care", "Completed/Archived", "Inactive", "Deseased", "Active"
            }

        }
        
    }

    
    override func viewDidAppear( _ animated: Bool) {
        // change navigation bar to custom color "fern"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0.27, green: 0.52, blue: 0.0, alpha: 1.0)
        self.title = "Patients by Referral Status"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white // "< Back" is white color in nav controler
        
    }
    
    
    //
    // MARK: - Supporting functions
    //
    



    
    //
    // MARK: - Table view data source
    //
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return whatAppointmentStatusButtonTapped//self.section[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    { //http://stackoverflow.com/questions/31381762/swift-ios-8-change-font-title-of-section-in-a-tableview
        //change font/text color title of section in a tableview
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 18)!
        header.textLabel?.textColor = UIColor.white
        //header.backgroundView?.backgroundColor = UIColor.red
        header.tintColor = UIColor(hex: 0x4A9FCA) //removes the default white tint section header colorto celestial blue 0x4A9FCA
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1//self.section.count
    }
    //Pending or Scheduled or Complete
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if whatAppointmentStatusButtonTapped == "Pending"{//section == 0 {
            return numberNewPatients
        }
        if whatAppointmentStatusButtonTapped == "Scheduled"{//
            return numberScheduledPatients
        }
        else {
            return numberCompletePatiets
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientcell", for: indexPath) as! PatientCell
        
        var Data = Dictionary<String,String>()
        
        // Configure the cell...
        
        if(whatAppointmentStatusButtonTapped == "Pending"){//indexPath.section == 0) {
            Data = pendingReferrals[indexPath.row]
            
            cell.appointmentID?.text = Data["Care_Plan_ID"]
            cell.statusImage?.image = UIImage(named: "orange.circle.png")
            cell.patientName?.text = Data["Patient_Name"]
            cell.AppointmentDate.text = Data["StartDate"]
            cell.patientNameTopConstraint.constant = 2
        }
        if(whatAppointmentStatusButtonTapped == "Scheduled"){//(indexPath.section == 1) {
            Data = scheduledReferrals[indexPath.row]
            
            cell.appointmentID?.text = Data["Care_Plan_ID"]
            cell.statusImage?.image = UIImage(named: "green.circle.png")
            cell.patientName?.text = Data["Patient_Name"]
            cell.AppointmentDate.text = Data["StartDate"]
            cell.patientNameTopConstraint.constant = 2
        }
        if(whatAppointmentStatusButtonTapped == "Complete"){//(indexPath.section == 2) {
            Data = completeReferrals[indexPath.row]
            
            cell.appointmentID?.text = Data["Care_Plan_ID"]
            cell.statusImage?.image = UIImage(named: "gray.circle.png")
            cell.patientName?.text = Data["Patient_Name"]
            cell.AppointmentDate.text = ""
            cell.patientNameTopConstraint.constant = 10
        }
        
           cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //http://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
        // " 1. click cell drag to view 2. select the “show” segue in the “Selection Segue” section. "
        
        if segue.identifier == "patientViewToDashBoard" {//this is the going back to the main dashboard
            //do something
        }
        if segue.identifier == "patientViewToReferrals" {
            //print("patientViewToReferrals segue")
            
            let selectedRow = ((PTVTableViewController.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
            var Data = Dictionary<String,String>()
            
            if whatAppointmentStatusButtonTapped == "Pending"{//section == 0 {
                Data = pendingReferrals[selectedRow]
            }
            if whatAppointmentStatusButtonTapped == "Scheduled"{//
                Data = scheduledReferrals[selectedRow]
            }
            else {
                Data = completeReferrals[selectedRow]
            }
            
            
            if let toViewController = segue.destination as? ReferralsVC {
                
                /* 1 */ toViewController.seguePatientNotes = Data["patient_notes"]
                /*   */ toViewController.seguePatientName = Data["Patient_Name"]
                /*   */ toViewController.seguePatientCPID = Data["Care_Plan_ID"]
                /* 4 */ toViewController.seguePatientDate = Data["StartDate"]
                /*   */ toViewController.segueHourMin = Data["date_hhmm"]
                /* 5 */ toViewController.segueBookMinutes = Data["book_minutes"]
                /* 6 */ toViewController.segueProviderName = Data["provider_name"]
                /*   */ toViewController.segueProviderID = Data["ServiceProvider_ID"]
                /* 7 */ toViewController.segueEncounterType = Data["book_type"]
                /* 8 */ toViewController.segueEncounterPurpose = Data["book_purpose"]
                /* 9 */ toViewController.segueLocationType = Data["location_type"]
                /* 10 */toViewController.segueBookPlace = Data["book_place"]
                /*    */toViewController.segueBookAddress = Data["book_address"]
                /* 11 */toViewController.seguePreAuth = Data["pre_authorization"]
                /* 12 */toViewController.segueAttachDoc = Data["Attachment_doc"]
                
                toViewController.segueStatus = whatAppointmentStatusButtonTapped //"Pending" or "Scheduled" or "Complete"
                
            }
            
        }


    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
