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
    
    
    let section = ["New/Pending", "Scheduled", "Completed/Archived"]
    
    
//    let appointmentIDs = [["90933","52718","12543","36221","160336","12718","68958","51500","27496"],
//                      ["7498","47598","46233","78543"],
//                      ["42321","36221","99699","25818","72021","372","86930","17498","23412","8975","76231"]]
    
//    let patients = [["Ruth Quinones", "Barrie Thomson", "Victor Owen", "Bill Summers", "Alice Njavro", "Michael Levi", "Elida Martinez", "John Banks","Rrian Nird"],
//                    [ "Cindy Lopper","Marx Ehrlich", "Alicia Watanabe", "Josh Brown"],
//                    [ "Desire Aller", "Paulita Wix", "Jenny Binkley", "Lawanda Arno", "Jackqueline Naumann", "Regine Kohnke","Brad Birdsong", "Dallas Remy", "Noel Devitt","Mike Brown","Sev Donada"]]
    
//    var times = [["12:32AM","01:56PM","03:22PM","11:12AM","10:52AM","12:01PM","07:02AM","05:05PM","07:25PM"],
//                 ["12:32AM","01:56PM","03:22PM","11:12AM"],
//                 ["12:32AM","01:56PM","03:22PM","11:12AM","10:52AM","12:01PM","07:02AM","05:05PM","07:25PM","09:43PM","10:52AM"]]
    
//    var dates = [["2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17"],
//                ["2/14/17","2/14/17","2/14/17","2/14/17"],
//                ["2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17"]]
//    
//    var appointmentMessage = [["Careflows update 1", "DISPOSITION Patient profile IDT Update",
//                         "order blood pressure plate", "Dr D. Webb Telemed update",
//                         "Patient profile Screening update", "Referrals details update",
//                         "syn patient card data", "Patient medication",
//                         "new nutrition levels"],
//                        ["new nutrition levels", "interface IDT Update",
//                        "Monitor infusion plasma", "DISPOSITION Patient profile IDT Update"],
//                        ["Patient profile Update", "Telemed update",
//                         "Patient profile Screening update", "Referrals details update",
//                         "monitor profile update 2", "Patient medication calculation",
//                         "patient Lunch Update", "hearing aid configuration","Dr D. Webb Telemed update",
//                         "Patient profile Screening update", "Referrals details update"]]
    
//    var addAppointment: [AnyObject] = Array()
    
    var appSec = [String]()
    var appID = [[String]]() //empty array of arrays of type string
    var appPat = [[String]]()
    var appTime = [[String]]()
    var appDate = [[String]]()
    var appMessage = [[String]]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //if isKeyPresentInUserDefaults(key: "onlyDoOnce") { //does this exist? [yes]

                getUpdateAppointmentData()
                print("getUpdateAppointmentData")

        //} else {//[no] does not exist
            //setUpAppointmentData()
            //print("setUpAppointmentData there is no key onlyDoOnce")
        //}
        
    }

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        PTVTableViewController.reloadData()
//    }

    
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
    
//    func setUpAppointmentData(){
//        
//            appID = appointmentIDs
//            appPat = patients
//            appTime = times
//            appDate = dates
//            appMessage = appointmentMessage
//        
//            //UserDefaults.standard.set(appSec, forKey: "appSec")
//            UserDefaults.standard.set(appID, forKey: "appID")
//            UserDefaults.standard.set(appPat, forKey: "appPat")
//            UserDefaults.standard.set(appTime, forKey: "appTime")
//            UserDefaults.standard.set(appPat, forKey: "appDate")
//            UserDefaults.standard.set(appMessage, forKey: "appMessage")
//        
//        //get whats in defaults
//            var onlyDoOnceHere = UserDefaults.standard.integer(forKey: "onlyDoOnce")
//        
//            if isKeyPresentInUserDefaults(key: "onlyDoOnce") { //does exist? in defaults [yes]
//                
//                onlyDoOnceHere += 1
//                
//            } else {// [no]
//                
//                onlyDoOnceHere = 1
//                
//            }
//        
//        //update defaults with new integer
//            UserDefaults.standard.set(onlyDoOnceHere, forKey: "onlyDoOnce")
//            UserDefaults.standard.synchronize()
//        
//    }
    
    func getUpdateAppointmentData(){
        //Get up to date array
        //let appSecT = UserDefaults.standard.object(forKey: "appSec")
        let appIDT = UserDefaults.standard.object(forKey: "appID")
        let appPatT = UserDefaults.standard.object(forKey: "appPat")
        let appTimeT = UserDefaults.standard.object(forKey: "appTime")
        let appDateT = UserDefaults.standard.object(forKey: "appDate")
        let appMessageT = UserDefaults.standard.object(forKey: "appMessage")
        
        //check default !nil then update public array from array stored in defaults
        //if let appSecT = appSecT {
        //    appSec = appSecT as! [String]
        //}
        
        if let appIDT = appIDT {
            appID = appIDT as! [[String]]
        }
        
        if let appPatT = appPatT {
            appPat = appPatT as! [[String]]
        }
        //------------------------------ time, date, message needed ViewController in main dash -------//
        if let appTimeT = appTimeT {
            appTime = appTimeT as! [[String]]
        }
        
        if let appDateT = appDateT {
            appDate = appDateT as! [[String]]
        }
        
        if let appMessageT = appMessageT {
            appMessage = appMessageT as! [[String]]
        }
        
    }
    
//    func appendAppointment(appointmentID: String, section: Int) {
//        //Get up to date array of arrays to append to
//        let arrayAppointment = UserDefaults.standard.object(forKey: "appointmentID")
//        
//        //check arrayAvailability !nil
//        if let arrayAppointment = arrayAppointment {
//            appID = arrayAppointment as! [[String]]
//        }
//        
//        appID[section].append(appointmentID) //add value to first section
//        //save entire array for this new availability to defaults
//        UserDefaults.standard.set(appID, forKey: "appointmentID")
//        UserDefaults.standard.synchronize()
//    }
    
    
    
//    func appendAppointmentObject(appointmentID: String, AppDay: String, AppTime: String, AppPatient: String, AppMessage: String, AppStatus: String)
//    {
//        //Get up to date array to append to
//        let arrayAppointment = UserDefaults.standard.object(forKey: "appointmentArray")
//        
//        //check arrayAvailability !nil
//        if let arrayAppointment = arrayAppointment {
//            addAppointment = arrayAppointment as! [AnyObject]
//        }
//        
//        let newAvailability = Appointments(withID: appointmentID, andDay: AppDay, andTime: AppTime, andPatient: AppPatient, andMessage: AppMessage, andStatus: AppStatus)
//        
//        let encodeNewAvail = NSKeyedArchiver.archivedData(withRootObject: newAvailability)
//        addAppointment.append(encodeNewAvail as AnyObject)
//        
//        //save entire array for this new availability to defaults
//        UserDefaults.standard.set(addAppointment, forKey: "availabilityArray")
//        UserDefaults.standard.synchronize()
//    }
//    
//    func fillAppointmentDate(){
//        appendAppointmentObject(appointmentID: appointmentIDs[0][0], AppDay: "2/14/17", AppTime: "2:30 AM", AppPatient: patients[0][0], AppMessage: "Careflow update 1", AppStatus: "New/Pending")
//        appendAppointmentObject(appointmentID: appointmentIDs[0][1], AppDay: "2/14/17", AppTime: "2:30 AM", AppPatient: patients[0][1], AppMessage: "Careflow update 1", AppStatus: "New/Pending")
//        
//        appendAppointmentObject(appointmentID: appointmentIDs[1][0], AppDay: "2/14/17", AppTime: "2:30 AM", AppPatient: patients[1][0], AppMessage: "Careflow update 1", AppStatus: "Scheduled")
//        appendAppointmentObject(appointmentID: appointmentIDs[1][1], AppDay: "2/14/17", AppTime: "2:30 AM", AppPatient: patients[1][1], AppMessage: "Careflow update 1", AppStatus: "Scheduled")
//        
//        appendAppointmentObject(appointmentID: appointmentIDs[2][0], AppDay: "2/14/17", AppTime: "2:30 AM", AppPatient: patients[2][0], AppMessage: "Careflow update 1", AppStatus: "Completed/Archived")
//        appendAppointmentObject(appointmentID: appointmentIDs[2][1], AppDay: "2/14/17", AppTime: "2:30 AM", AppPatient: patients[2][1], AppMessage: "Careflow update 1", AppStatus: "Completed/Archived")
//    }
    
    
    
    //
    // MARK: - Table view data source
    //
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
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
        return self.section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #return the number of rows
        return self.appPat[section].count//patients[section].count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientcell", for: indexPath) as! PatientCell
        
        // Configure the cell...
        
        cell.appointmentID?.text = self.appID[indexPath.section][indexPath.row]//self.appointmentIDs[indexPath.section][indexPath.row]
        cell.patientName?.text = self.appPat[indexPath.section][indexPath.row]//self.patients[indexPath.section][indexPath.row]
        
        if(indexPath.section == 0) {
            cell.statusImage?.image = UIImage(named: "orange.circle.png")}
        if(indexPath.section == 1) {
            cell.statusImage?.image = UIImage(named: "green.circle.png")}
        if(indexPath.section == 2) {
            cell.statusImage?.image = UIImage(named: "gray.circle.png")}
        
           cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //http://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
        // " 1. click cell drag to view 2. select the “show” segue in the “Selection Segue” section. "
        
        if segue.identifier == "patientViewToDashBoard" {//this is the going back to the main dashboard
            //do something
        }
        else {
            let selectedRow = ((tableView.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
            let sectionOfSelectedRow = (tableView.indexPathForSelectedRow?.section)! //retuns int
            //print("\\(selectedRow)" + " \\(sectionOfSelectedRow)")
            let patientName = appPat[sectionOfSelectedRow][selectedRow]// + "'s Information" as String
            let appointmentID = appID[sectionOfSelectedRow][selectedRow] as String
            let patientStatus = section[sectionOfSelectedRow]
            
            // Store data locally change to mySQL? server later
            let defaults = UserDefaults.standard
            defaults.set(patientName, forKey: "patientName")
            defaults.set(appointmentID, forKey: "appointmentID")
            defaults.set(patientStatus, forKey: "patientStatus") //need this to hide the accept and decline buttons in completed view
            defaults.set(selectedRow, forKey: "selectedRow")
            defaults.set(sectionOfSelectedRow, forKey: "sectionForSelectedRow")
            defaults.synchronize()
            
            //            if let dest = segue.destination as? EventViewController {\
            //                if let eventObject = events[selectedRow] as? Data {
            //                    let se = NSKeyedUnarchiver.unarchiveObject(with: eventObject) as! ScenarioEvent
            //                    dest.scenarioEvent = se
            //                }
            //            }
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
