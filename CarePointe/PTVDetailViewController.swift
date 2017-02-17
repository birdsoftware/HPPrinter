//
//  PTVDetailViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/31/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PTVDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var patientNameLabel: UILabel!
    
    //buttons
    @IBOutlet weak var completedPatientButton: UIButton!
    @IBOutlet weak var declinePatientButton: UIButton!
    @IBOutlet weak var acceptPatientButton: UIButton!
    @IBOutlet weak var careTeamButton: UIButton!
    
    //table view
    @IBOutlet weak var patientInfoDataTable: UITableView!
    
    // 1
    var expandedLabel: UILabel!
    var indexOfCellToExpand: Int!
    var IndexPathRow: Int!
    //var cellIsExpanded: Bool
    
    var patientTitles = ["  Patient and Contact Information", "  Insurance Information", "  Appointment Details", " Appointment History"]
    
    var patientDescription = ["\nName: Ruth Quinones \nGender: Female \nEthnicity: Hispanic/Latino \nSSN#: 343-14-3434 \nDOB: 07/10/1947 \nPrimary Language: English \n\nHome Address: 8225 Benson Dr \nCity: Phoenix \nState: AZ \nZip: 89123 \nPhone: (816) 679-4482 \nCell: (702) 688-9673 \nAdditional Contact: Marie Smith \nContact Relationship: Sister",
                              "\nPrimary Source: Medicare \nAccount#123344324: \nMedicaid: \nPrimary Commercial: \nInsurance: 21 ST Century & Health Benefits, 3P Administrators",
                              "\nVestibulum consectetur ultricies elit, eu luctus nunc interdum eu. Phasellus elementum leo non lorem ornare rutrum id in tortor. Quisque mollis dui a mi efficitur ultricies. Aenean a porttitor enim. Quisque vel felis leo. Aenean mi erat, sollicitudin at iaculis id, convallis rutrum purus.",
                              "\n Date            Name                       Status\n 1/3/2017     Jennifer Johnson    Accepted\n 1/5/2017     Jeff Johnson           Declined\n 1/6/2017     Jennifer Johnson    Accepted\n 1/7/2017     Jennifer Johnson    Accepted\n 1/9/2017     Jennifer Johnson    Accepted"]

    var appSec = [String]()
    var appID = [[String]]() //empty array of arrays of type string
    var appPat = [[String]]()
    var appTime = [[String]]()
    var appDate = [[String]]()
    var appMessage = [[String]]()
    var patientName = "test"
    var appointmentID = "0123"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indexOfCellToExpand = 0
        
        // round button corners
        acceptPatientButton.layer.cornerRadius = 5
        declinePatientButton.layer.cornerRadius = 5
        completedPatientButton.layer.cornerRadius = 5
        //careTeam button round button
        careTeamButton.layer.cornerRadius = 0.5 * careTeamButton.bounds.size.width
        careTeamButton.clipsToBounds = true
        
        // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        patientName = UserDefaults.standard.string(forKey: "patientName")!
        patientNameLabel.text = patientName + "'s Information"
        
        // show/hide view UI elements based on status
        let patientStatus = UserDefaults.standard.string(forKey: "patientStatus")
        updatePatientView(status: patientStatus!)
        
        appointmentID = UserDefaults.standard.string(forKey: "appointmentID")!
        
        //Table View datasource/delegate setup
        patientInfoDataTable.delegate = self //table view
        patientInfoDataTable.dataSource = self
        
        //Table ROW Height set to auto layout
        patientInfoDataTable.rowHeight = UITableViewAutomaticDimension
        patientInfoDataTable.estimatedRowHeight = 150

    }
    
    
    
    
    //
    //#MARK - Supporting functions
    //

    func updatePatientView(status: String){
        switch status {
        case "New/Pending":                         //Show accept decline, hide completed
            completedPatientButton.isHidden = true
        case "Scheduled":                           //Show completed, hide accept decline
            acceptPatientButton.isHidden = true
            declinePatientButton.isHidden = true
            completedPatientButton.isHidden = false
        case "Completed/Archived":                           //hide all
            acceptPatientButton.isHidden = true
            declinePatientButton.isHidden = true
            completedPatientButton.isHidden = true
        default:
            print("fail: updatePatientView")
        }
        
    }
    
    func movePatientToSection(SectionNumber: Int){
        // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        let selectedRow = UserDefaults.standard.integer(forKey: "selectedRow")
        let sectionForSelectedRow = UserDefaults.standard.integer(forKey: "sectionForSelectedRow")
        let completedSection = SectionNumber // 2 = completed // 1 = accepted
        
       /*  
         *  remove appointmentID from [sectionForSelectedRow][selectedRow]
         *  remove patients from [sectionForSelectedRow][selectedRow]
         *  append appointmentID to [completedSection][lastRow] [2][n]
         *  append patients to [completedSection][lastRow]
         *  replace whats in user defualts with new arrays
         */
        
        //Get up to date arrays for appID, appPat
            GetAppointmentFromDefaults()
            let associatedTime = appTime[sectionForSelectedRow][selectedRow]
            let associatedDay = appDate[sectionForSelectedRow][selectedRow]
            let associatedMessage = appMessage[sectionForSelectedRow][selectedRow]
        
        //remove appointmentID & patient from [sectionForSelectedRow][selectedRow]
            appID[sectionForSelectedRow].remove(at: selectedRow)
            appPat[sectionForSelectedRow].remove(at: selectedRow)
            appTime[sectionForSelectedRow].remove(at: selectedRow)
            appDate[sectionForSelectedRow].remove(at: selectedRow)
            appMessage[sectionForSelectedRow].remove(at: selectedRow)
        
        //append appointmentID & patient
            appID[completedSection].append(appointmentID)
            appPat[completedSection].append(patientName)
            appTime[completedSection].append(associatedTime)
            appDate[completedSection].append(associatedDay)
            appMessage[completedSection].append(associatedMessage)
        
        //update defaults from public arrays above
            //UserDefaults.standard.set(appSec, forKey: "appSec")
            UserDefaults.standard.set(appID, forKey: "appID")
            UserDefaults.standard.set(appPat, forKey: "appPat")
            UserDefaults.standard.set(appTime, forKey: "appTime")
            UserDefaults.standard.set(appDate, forKey: "appDate")
            UserDefaults.standard.set(appMessage, forKey: "appMessage")

    }

    func GetAppointmentFromDefaults(){
        
        let appIDT = UserDefaults.standard.object(forKey: "appID")
        let appPatT = UserDefaults.standard.object(forKey: "appPat")
        let appTimeT = UserDefaults.standard.object(forKey: "appTime")
        let appDateT = UserDefaults.standard.object(forKey: "appDate")
        let appMessageT = UserDefaults.standard.object(forKey: "appMessage")
    
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
    
    //
    // #MARK: - Button Actions
    //
    
    @IBAction func declinePatientButtonTapped(_ sender: Any) {
        //let patientName = UserDefaults.standard.string(forKey: "patientName")
        
        // show Alert, ask why, get leave a note text, show [Submit] [Cancel] buttons
        let alert = UIAlertController(title: "Decline Patient",
                                      message: "Submit decline patient for "+patientName,
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            
            print(textField.text!)
            
            let completed = 2
            self.movePatientToSection(SectionNumber: completed)
            
            // Instantiate a view controller from Storyboard and present it
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
            self.present(vc, animated: false, completion: nil)
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // Add 1 textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Reason for declining this patient?"
            textField.clearButtonMode = .whileEditing
        }
        
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

    }
    
    @IBAction func acceptPatientButtonTapped(_ sender: Any) {
        
        
        // Move this New patient to Accepted
        let accepted = 1
        self.movePatientToSection(SectionNumber: accepted)
        
        
        //show segue modally identifier: newPatientAppointment
        self.performSegue(withIdentifier: "newPatientAppointment", sender: self)
        
        
        // Instantiate a view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }

    
    
    @IBAction func completedPatientButtonTapped(_ sender: Any) {
        
        let completed = 2
        self.movePatientToSection(SectionNumber: completed)
        
    }
    
    //
    // #MARK: - UNWIND SEGUE
    //
    
    //https://www.andrewcbancroft.com/2015/12/18/working-with-unwind-segues-programmatically-in-swift/
    @IBAction func unwindToPatientDashboard(segue: UIStoryboardSegue) {}
    
    //
    // #MARK: - Table View
    //
    
    func expandCell(sender: UITapGestureRecognizer) //IndexPathRow
    {
        let label = sender.view as! UILabel
        IndexPathRow = label.tag
        
        let cell: PatientInformationCell = patientInfoDataTable.cellForRow(at: IndexPath(row: IndexPathRow, section: 0)) as! PatientInformationCell
        
        cell.longDescription.text = self.patientDescription[IndexPathRow]
        indexOfCellToExpand = IndexPathRow
        //cell.patientTitle.backgroundColor = UIColor.blue
        patientInfoDataTable.reloadRows(at: [IndexPath(row: IndexPathRow, section: 0)], with: .fade)
        patientInfoDataTable.scrollToRow(at: IndexPath(row: IndexPathRow, section: 0), at: .top, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //[2] RETURN number of ROWS in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientTitles.count
    }
    
    //[3] RETURN actual CELL to be displayed
    func tableView(_ tableView: UITableView, cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientdetailcell", for: IndexPath) as! PatientInformationCell
        cell.patientTitle.text = patientTitles[IndexPath.row]
        cell.longDescription.text = patientDescription[IndexPath.row]
        cell.patientTitle.tag = IndexPath.row
        
        IndexPathRow = IndexPath.row
        //Add Gesture Recognizer to cell
        let tap = UITapGestureRecognizer(target: self, action: #selector(PTVDetailViewController.expandCell(sender:)))
        cell.patientTitle.addGestureRecognizer(tap)
        cell.patientTitle.isUserInteractionEnabled = true
        
        return cell
    }
    
    // Set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == indexOfCellToExpand
        {
            //print(cellIsExpanded)
            //cellIsExpanded = !cellIsExpanded
            return 225
        }
        return 60
    }

    
    
}
