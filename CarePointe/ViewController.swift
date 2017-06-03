//
//  ViewController.swift
//  CarePointe
//
//  Created by Brian Bird  on 12/12/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//  https://www.youtube.com/watch?v=a5pzlbBnfYg log in example
//  http://stackoverflow.com/questions/25630315/autolayout-unable-to-simultaneously-satisfy-constraints debugging constraints

import UIKit
import UXCam

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    //
    // Outlets
    //
    
    // buttons
    //@IBOutlet weak var AddTaskButton: UIButton!
    @IBOutlet weak var pendingReferralsButton: UIButton!
    @IBOutlet weak var scheduledEncountersButton: UIButton!
    @IBOutlet weak var CompleteButton: UIButton!
    @IBOutlet weak var dateDisplayButton: UIButton!
    
    
    //view
    @IBOutlet var mainView: UIView!
    
    
    // labels
    @IBOutlet weak var pendingPatientsLabel: UILabel!
    @IBOutlet weak var scheduledAppointLabel: UILabel!
    @IBOutlet weak var unreadMessagesLabel: UILabel!
    @IBOutlet weak var orangeLine1: UILabel!
    @IBOutlet weak var orangeLine2: UILabel!
    @IBOutlet weak var orangeLine3: UILabel!
    @IBOutlet weak var noAppointmentsTodayLabel: UILabel!
    
    // table views
    @IBOutlet weak var tasksTableView: UITableView!
    //@IBOutlet weak var contactsTable: UITableView!
    
    
    // bar buttons
    @IBOutlet weak var hamburger: UIBarButtonItem!
    @IBOutlet weak var rightBarButtonAlert: UIBarButtonItem!
    
    //
    // Class Variables
    //
    
    var w:Int = 0
    var h:Int = 0

    
    var strDate:String = ""

    
    //
    // Class Public Data
    //
    var uniqueValues = Set<String>()
    var appID = [String]()
    var appointmentID = [String]()
    var appPat = [String]()       //Displayed in Table called tasksTableView
    var appTime = [String]()        //Displayed in Table
    var appDate = [String]()
    var appMessage = [String]()   //Displayed in Table
    var addresses = [String]() //for map in table
    
    // Date Picker -> reload table using:
    var filteredAppID:[String] = []
    var filteredDates:[String] = []
    var filteredTime:[String] = []
    var filteredPatient:[String] = []
    var filteredMessage:[String] = []
    var filterAppointmentID:[String] = []
    var filterAddresses:[String] = []
    
    var filterActive : Bool = false
    
//    // Search Bar (top nav controller title view) ------------------------
//    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x:0,y:0,width:200,height:200))
//    var searchActive : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //HIDE THINGS FOR NEW UPDATE: HOME screen
        self.rightBarButtonAlert.tintColor = .clear
        self.rightBarButtonAlert.isEnabled = false

        
        if isKeyPresentInUserDefaults(key: "userProfile") {
            let userProfile = UserDefaults.standard.object(forKey: "userProfile") as? Array<Dictionary<String,String>> ?? []
            
            if userProfile.isEmpty == false {
                //let user = userProfile[0]
               // let name = user["userName"]!
                //let title = user["Title"]!
                //let role = user["RoleType"]!
        UXCam.tagUsersName("brian")//"\(name), \(title), \(role)")
            }
        }

        //get screen size for determining the autolayout bounds for the alert and hamburger views
        w  = Int(mainView.bounds.size.width) //print("Screen Width: \(w)")
        h  = Int(mainView.bounds.size.height) //print("Screen Height: \(h)")
        
        // Update Badge # HERE if DELETE occurred in Alert Table ----------------
        //NEW UPDATE: HOME screen
//        NotificationCenter.default.addObserver(self,
//                selector:#selector(updateAlertBadgeNumber),
//                name: NSNotification.Name(rawValue: "updateAlert"),
//                object: nil)
        
        // LOG OUT After 30 Minutes
        //let thirtyMinutes: TimeInterval = 3600.0
        Timer.scheduledTimer(timeInterval: 3600.0,
                             target: self,
                             selector: #selector(logOutAfter30Minutes),
                             userInfo: nil,
                             repeats: true)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(logOutAfter30Minutes), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)

        
        //delegation
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        //contactsTable.dataSource = self
        //contactsTable.delegate = self
        
        tasksTableView.rowHeight = UITableViewAutomaticDimension
        tasksTableView.estimatedRowHeight = 150
        //contactsTable.rowHeight = UITableViewAutomaticDimension
        //contactsTable.estimatedRowHeight = 150
        
        // UI Set Up
        
            // TOP SEARCH BAR Set up -------------------------------------------
                // Initialize and set up the search controller
                // http://swift.attojs.com/index.php/2016/03/21/how-to-make-uisearchbar-programmatically/
//                searchBar.delegate = self
//                searchBar.placeholder = "Start Communication"
//                //definesPresentationContext = true
//        
//                //var titleNavBarButton = UIBarButtonItem(customview: searchBar)
//                self.navigationItem.titleView = searchBar
//        
//                // set Default bar status.
//                searchBar.searchBarStyle = UISearchBarStyle.prominent//.default
//        
//                // change the color of cursol and cancel button.
//                searchBar.tintColor = .black
//        
//                //searchBar.sizeToFit()//need?
        
        
            noAppointmentsTodayLabel.isHidden = true
        
        // HAMBURGER MENU --------------------------------------------------------
            //1. Determine device Type and set alert & hamburger view offsets
            //setHideAndShowOffsetFromDeviceType()
            //2. Move slide menues off screen
            //moveSlideMenu(Menu: "hideHamburgerView")
            //moveSlideMenu(Menu: "hideAlertView")
            //3. Cast shadow along slide out menu edge for 3D effect
            //hamburgerContainerView.layer.shadowOpacity = 1
            //alertContainerView.layer.shadowOpacity = 1
        
        // SET CURRENT DATE TIME & dateDisplayButton UI ---------------------------
            self.setCurrentDateInDefaults()
            let currentDateFromDefaults = UserDefaults.standard.string(forKey: "currentDate")
            self.dateDisplayButton.setTitle(currentDateFromDefaults, for: .normal)
            dateDisplayButton.layer.cornerRadius = 5
        
        // DRAW White thin line [] | [] | [] between buttons ----------------------------
            pendingReferralsButton.layer.addBorder(edge: UIRectEdge.right, color: .white, thickness: 0.5)
            CompleteButton.layer.addBorder(edge: UIRectEdge.left, color: .white, thickness: 0.5)
        // DRAW Orange line below number labels
            orangeLine1.layer.addBorder(edge: UIRectEdge.bottom, color: .orange, thickness: 2)
            orangeLine2.layer.addBorder(edge: UIRectEdge.bottom, color: .orange, thickness: 2)
            orangeLine3.layer.addBorder(edge: UIRectEdge.bottom, color: .orange, thickness: 2)
        
        // GET DATA FROM DEFAULTS --------------------------------------------------
        if isKeyPresentInUserDefaults(key: "onlyDoOnce") { //does this exist? [yes]
            getUpdateAppointmentData()
            //print("getUpdateAppointmentData")
        } else {//[no] does not exist
            setUpAppointmentData()
            //print("setUpAppointmentData there is no key onlyDoOnce")
        }
        
        
        // RELOAD table based on current date if date not selected from PICKER -----
        if (strDate.isEmpty == true) {
            updateTableByDate(searchText: currentDateFromDefaults!)
        } else {
            updateTableByDate(searchText: strDate)
        }
        
        // ADD BADGE to Right Bar Button Item in nav controller --------------------
        //HIDE THINGS FOR NEW UPDATE: HOME screen
//        var alertCount = 0
//        if isKeyPresentInUserDefaults(key: "alertCount") {
//            alertCount = UserDefaults.standard.integer(forKey: "alertCount")
//        }
//        rightBarButtonAlert.addBadge(number: alertCount)//alertImageNames.count)
        
        
        // DISPLAY "No Appointments for this Day -----------------------------------
        showAlertIfTasksTableEmpty()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //check if user is signed in ELSE go to Sign In View
        let isUserSignedIn = UserDefaults.standard.bool(forKey: "isUserSignedIn")
        if(!isUserSignedIn)
        {
            //self.performSegue(withIdentifier: "ShowLogInView", sender: self)
            self.performSegue(withIdentifier: "Show4ButtonView", sender: self)
        }
        
        // change navigation bar to custom color "fern"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0.27, green: 0.52, blue: 0.0, alpha: 1.0)
        
        
        //save appointments count, inbox patients count
        var numberNewPatients = 0
        var numberScheduledPatients = 0
        var numberCompletePatiets = 0
        
        if isKeyPresentInUserDefaults(key: "RESTAllReferrals"){
            let referrals = UserDefaults.standard.value(forKey: "RESTAllReferrals") as! Array<Dictionary<String,String>>
            
            for referral in referrals {
                
                print("referral\(referral["Care_Plan_ID"]!) \(referral["Status"]!)")

                switch referral["Status"]! //from tbl_care_plan
                {
                    case "Complete", "Rejected/Inactive", "Cancelled":
                        numberCompletePatiets += 1
                    
                    case "Scheduled", "In Service":
                        numberScheduledPatients += 1
                        let beforeInsertCount = uniqueValues.count
                        uniqueValues.insert(referral["Care_Plan_ID"]!) // will do nothing if Care_Plan_ID exists already
                        let afterInsertCount = uniqueValues.count
                        
                        if beforeInsertCount != afterInsertCount {
                            
                            self.addresses.append(referral["book_address"]!)
                            self.appointmentID.append(referral["Care_Plan_ID"]!)//referral ID is Care_Plan_ID
                            self.appDate.append(convertDateStringToDate(longDate: referral["StartDate"]!))//StartDate
                            self.appPat.append(referral["Patient_Name"]!)//Patient_Name
                            self.appMessage.append(referral["book_type"]!)//book_type
                            self.appID.append(referral["Patient_ID"]!)//Patient_ID
                            var hhmmStr = referral["date_hhmm"]!
                            
                            //check to makre sure Data["date_hhmm"]! has ":" if not insert ":"
                            let charset = CharacterSet(charactersIn: ":")
                            
                            if hhmmStr.rangeOfCharacter(from: charset) == nil {
                                
                                hhmmStr = ":"+hhmmStr
                            }
                            
                            let hourMinuteString = convertStringTimeToString_hh_mm_a(date_hhmm: hhmmStr)
                            self.appTime.append(hourMinuteString)//date_hhmm
                        }
                    
                    case "Pending", "Opened":
                        numberNewPatients += 1
                    default:
                        break
                } //Others:"Not Taken Under Care", "Completed/Archived", "Inactive", "Deseased", "Active"
                
            }
            
            //update table
            let date = Date()
            let formatter = DateFormatter()
            
            //formatter.dateFormat = "M/dd/yy" //"2/04/2017"
            formatter.dateStyle = .short //"2/4/2017"
            
            let todaysDate = formatter.string(from: date)
            
            // RELOAD table based on current date if date not selected from PICKER -----
            if (strDate.isEmpty == true) {
                updateTableByDate(searchText: todaysDate)
            } else {
                updateTableByDate(searchText: strDate)
            }
        }
        
        
        UserDefaults.standard.set(numberScheduledPatients, forKey: "numberScheduledPatients")
        UserDefaults.standard.set(numberNewPatients, forKey: "numberNewPatients")
        UserDefaults.standard.synchronize()
        
        pendingPatientsLabel.text = "\(numberNewPatients)"
        scheduledAppointLabel.text = "\(numberScheduledPatients)"
        unreadMessagesLabel.text = "\(numberCompletePatiets)"
        
    }
    
    
    //
    // #MARK: - Button Actions
    //

    
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        UserDefaults.standard.set("Complete", forKey: "whatAppointmentStatusButtonTapped")
        UserDefaults.standard.synchronize()

        // Instantiate a view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }

    
    
    @IBAction func pendingReferralsButtonTapped(_ sender: Any) {
        
        UserDefaults.standard.set("Pending", forKey: "whatAppointmentStatusButtonTapped")
        UserDefaults.standard.synchronize()
        
        // Instantiate a view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
    @IBAction func scheduledEncountersButtonTapped(_ sender: Any) {
        
        UserDefaults.standard.set("Scheduled", forKey: "whatAppointmentStatusButtonTapped")
        UserDefaults.standard.synchronize()
        
        // Instantiate a view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
    @IBAction func dateDisplatButtonTapped(_ sender: Any) {
        showCalendarAlert()
    }
    
    
    @IBAction func hamburgerBarButtonTapped(_ sender: Any) {
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController
        //vc.navigationController?.pushViewController(vc, animated: false)
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
    
    //
    // #MARK: - Supporting Functions
    //

    //HIDE THINGS FOR NEW UPDATE: HOME screen
//    @objc func updateAlertBadgeNumber(){//newNumber: Int) {
//        let alertCount = UserDefaults.standard.integer(forKey: "alertCount")
//        rightBarButtonAlert.updateBadge(number: alertCount)//newNumber) //rightBarButtonAlert: UIBarButtonItem!
//        
//    }
    
    // --- LOG OUT AFTER 30 MINUTES ---
    func logOutAfter30Minutes() {
        
        UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.synchronize()
        
        //self.performSegue(withIdentifier: "ShowLogInView", sender: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "signinvc") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    

    
    func showCalendarAlert(){
        //var searchText = "2/14/17"
        
        DatePickerDialog().show("Appointment Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if date != nil {
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = DateFormatter.Style.short
                //dateFormat.timeStyle = DateFormatter.Style.short --NO TIME
                self.strDate = dateFormat.string(for: date!)!
                //self.dateLabel.text = "\(strDate)"
                self.dateDisplayButton.setTitle(self.strDate, for: .normal)
                UserDefaults.standard.setValue(self.strDate ,forKey: "newDate")
                
                //----- UPDATE TABLE BY DATE SELECTED ---------
                self.updateTableByDate(searchText: self.strDate)
                
            }
        }
        //Save new date to user defaults
        UserDefaults.standard.set(true, forKey: "didUpdateCalendarDate") //need check to display a date if no date selected
        
        //UPDATE TABLE FROM SQL DB      DBtime, DBpatient, DBtasks for a given DB date
        
    }
    
    func updateTableByDate(searchText: String) {
    
        //searchText = strDate //This contains date selected "2/17/17"
        
        if (appDate.isEmpty == false) {
            //print("There are appDate objects!")
        
            var integerArray:[Int] = []
        
            self.filteredDates = self.appDate.filter({ (text) -> Bool in
                let tmp: NSString = text as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                
                //filteredAlertImages = alertImageNames.filter({text -> Bool in range.location != NSNotFound})
                
                integerArray.append(range.location)
                return range.location != NSNotFound //NSNotFound is NSIntegerMax range.location if item not found returns 2^63 or 9223372036854775807
            })
            
            
            var index = 1
            self.filteredTime.removeAll()
            self.filteredPatient.removeAll()
            self.filteredMessage.removeAll()
            self.filteredAppID.removeAll()
            self.filterAppointmentID.removeAll()
            self.filterAddresses.removeAll()
            for i in integerArray {
                if i != NSNotFound {
                    //TEST print("match \(i),\(index)") //testing
                    //add
                    self.filteredTime.append(self.appTime[index-1])
                    self.filteredPatient.append(self.appPat[index-1])
                    self.filteredMessage.append(self.appMessage[index-1])
                    self.filteredAppID.append(self.appID[index-1])
                    self.filterAppointmentID.append(self.appointmentID[index-1])
                    self.filterAddresses.append(self.addresses[index-1])
                    if(index < integerArray.count) {
                        index += 1
                    }
                }
                else {
                    //remove
                    //TEST print("not match \(i),\(index)") //testing
                    if(index < integerArray.count) {
                        index += 1
                    }
                }
            }
            
            print("self.filteredDates: \(self.filteredDates)")
            
            self.filterActive = true;

            showAlertIfTasksTableEmpty()
            
            self.tasksTableView.reloadData()
        }
        
        //print("There are no appDate objects!")
    }
    

    
    func getUpdateAppointmentData(){
        
        appID = [""]//Patient_ID
        appointmentID = [""]
        appPat = [""]//Patient_Name
        appTime = [""]//
        appDate = [""]//
        appMessage = [""]//book_type like Nurse visit
        addresses = [""]
        
    }

    func setUpAppointmentData(){
        
        self.setUpPatientDataInDefaults()
        getUpdateAppointmentData()
        //get whats in defaults
        let onlyDoOnceHere = 1//UserDefaults.standard.integer(forKey: "onlyDoOnce")
        
        UserDefaults.standard.set(onlyDoOnceHere, forKey: "onlyDoOnce")
        UserDefaults.standard.synchronize()
        
    }

    func showAlertIfTasksTableEmpty() {
    
        if(filterActive && filteredMessage.isEmpty){
                
                noAppointmentsTodayLabel.isHidden = false
            
        } else if(appPat.isEmpty) {
                
                noAppointmentsTodayLabel.isHidden = false
 
            }
        
        else {
            
            noAppointmentsTodayLabel.isHidden = true
        }
    }
    
    
    //
    // #MARK: - UNWIND SEGUE
    //
    
    //https://www.andrewcbancroft.com/2015/12/18/working-with-unwind-segues-programmatically-in-swift/
    @IBAction func unwindToMainDashboard(segue: UIStoryboardSegue) {}
    
    
    //
    // #MARK: - Table View
    //
    
    //[2] RETURN number of ROWS in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == tasksTableView){
            if(filterActive) {
                return filteredDates.count
            }
            
            if (appDate.isEmpty == false) {
                //print("There are appDate objects!")
                return appPat.count//patients.count
            }
        }

        return 0
        
    }
    
    func returnNotEmptyAddressString(adress: String) -> String {
        /* INPUT: "Address -1 main street;State -NY;City -Bedminster;Zip -07921;Phone -8886337821;"
         * ["Address -1 main street",
         *  "State -NY",
         *  "City -Bedminster",
         *  "Zip -07921",
         *  "Phone -8886337821",
         *  ""]
         * For each element in address must contain a "-" and doesnot contain "Phone"
         * OUTPUT: "1 main street, NY, Bedminster, 07921"
         */
        
        let segueBookAddress = adress
        
        if segueBookAddress.contains(";") {
            
            let bookAddressArray = splitStringToArray(StringIn: segueBookAddress, deliminator: ";")
            
            var addr = ""
            
            for element in bookAddressArray {
                if element.contains("-") {
                    if element.range(of: "Phone") == nil {//does not exist
                        let index = element.characters.index(of: "-")
                        var dashStr = element.substring(from: index!) + ", "
                        dashStr.remove(at: dashStr.startIndex)
                        addr += dashStr
                    }
                }
            }
            
            let endIndex = addr.index(addr.endIndex, offsetBy: -2)
            let truncated = addr.substring(to: endIndex)
            return truncated
            
        } else {
            
            return segueBookAddress
        }
    }

    
    func goToMap(sender: UIButton) {
        
        let selectedRow = sender.tag //returns int
        let selectedAdress = filterAddresses[selectedRow]
        let searchableAddress = returnNotEmptyAddressString(adress: selectedAdress)
        let patientAddress = "\(searchableAddress)"//, \(city), \(state) \(zip)"
        
        let callMapHere = ReferralsMap()
        callMapHere.showMap(destAddress: patientAddress, destName: "Patient Address")
    }
    
    //[3] RETURN actual CELL to be displayed
    
    // SHOW SEGUE ->
    // " 1. click cell drag to second view. select the “show” segue in the “Selection Segue” section. "
    //http://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
    func tableView(_ tableView: UITableView, cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        //if(tableView == tasksTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "apptCell")! as! AppointmentCell
            cell.photo.image = UIImage(named: "green.circle.png")//photos[IndexPath.row]
            
            if(filterActive){

                cell.patient.text = filteredMessage[IndexPath.row]
                cell.task.text = filteredPatient[IndexPath.row]
                cell.time.text = filteredTime[IndexPath.row]
                cell.mapButton.tag = IndexPath.row
                
                if filterAddresses[IndexPath.row] != "" {
                    cell.mapButton.isHidden = false
                    cell.mapButton.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
                } else {
                    cell.mapButton.isHidden = true
                }
            }
            else {
            
                cell.patient.text = appMessage[IndexPath.row]//appointments[IndexPath.row]
                cell.task.text = appPat[IndexPath.row]//patients[IndexPath.row]
                cell.time.text = appTime[IndexPath.row]//times[IndexPath.row]
                
            }
            
            cell.accessoryType = .disclosureIndicator // add arrow > to cell
            
            return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addNoteCompletePatient" {//AddNoteCompletePatientViewController
            
            let selectedRow = ((tasksTableView.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
            
            let accepted = 1
            
            UserDefaults.standard.set(selectedRow, forKey: "selectedRow")
            UserDefaults.standard.set(accepted, forKey: "sectionForSelectedRow")
            
            if let toVC = segue.destination as? AddNoteCompletePatientViewController{
                
                toVC.patient = filteredPatient[selectedRow]//patient name
                toVC.patientID = filteredAppID[selectedRow]//Patient_ID from RESTReferral
                toVC.appointmentID = filterAppointmentID[selectedRow]//referral ID is Care_Plan_ID
            }
        }
    }
    
    
}



