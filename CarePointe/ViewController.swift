//
//  ViewController.swift
//  CarePointe
//
//  Created by Brian Bird  on 12/12/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//  https://www.youtube.com/watch?v=a5pzlbBnfYg log in example
//  http://stackoverflow.com/questions/25630315/autolayout-unable-to-simultaneously-satisfy-constraints debugging constraints

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    //
    // Outlets
    //
    
    // buttons
    @IBOutlet weak var AddTaskButton: UIButton!
    @IBOutlet weak var pendingReferralsButton: UIButton!
    @IBOutlet weak var scheduledEncountersButton: UIButton!
    @IBOutlet weak var unreadMessagesButton: UIButton!
    @IBOutlet weak var dateDisplayButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var hamburgerOutsideButton: UIButton!
    @IBOutlet weak var alertOutsideButton: UIButton!

    // views
    @IBOutlet weak var hamburgerContainerView: UIView!
    @IBOutlet weak var alertContainerView: UIView!
    
    
    // labels
    @IBOutlet weak var pendingPatientsLabel: UILabel!
    @IBOutlet weak var scheduledAppointLabel: UILabel!
    @IBOutlet weak var unreadMessagesLabel: UILabel!
    @IBOutlet weak var orangeLine1: UILabel!
    @IBOutlet weak var orangeLine2: UILabel!
    @IBOutlet weak var orangeLine3: UILabel!
    @IBOutlet weak var noAppointmentsTodayLabel: UILabel!
    
    // tabel views
    @IBOutlet weak var tasksTableView: UITableView!
    
    // bar buttons
    @IBOutlet weak var hamburger: UIBarButtonItem!
    @IBOutlet weak var rightBarButtonAlert: UIBarButtonItem!
    
    // constraints
    @IBOutlet weak var leadingConstraintContainerView: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraintContainerView2: NSLayoutConstraint!
    @IBOutlet weak var phoneButtonHeight: NSLayoutConstraint!
    
    
    //
    // Class Variables
    //
    
    var alertOffset: CGFloat = 0
    var hambuOffset: CGFloat = 0
    var hamburgerMenuShowing = false
    var alertTableShowing = false
    
    
    //
    // Class Public Data
    //
    
    
    var appID = [[String]]()
    var appPat = [[String]]()       //Displayed in Table called tasksTableView
    var appTime = [[String]]()        //Displayed in Table
    var appDate = [[String]]()
    var appMessage = [[String]]()   //Displayed in Table
    
    // Date Picker -> reload table using:
    var filteredAppID:[String] = []
    var filteredDates:[String] = []
    var filteredTime:[String] = []
    var filteredPatient:[String] = []
    var filteredMessage:[String] = []
    
    var filterActive : Bool = false
    
    // Search Bar (top nav controller title view)
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x:0,y:0,width:200,height:200))
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self,
                selector:#selector(updateAlertBadgeNumber),
                name: NSNotification.Name(rawValue: "updateAlert"),
                object: nil)
        
        // UI Elements Set Up
            //set up search bar
            // Initialize and set up the search controller
            // http://swift.attojs.com/index.php/2016/03/21/how-to-make-uisearchbar-programmatically/
                searchBar.delegate = self
                searchBar.placeholder = "Start Communication"
                //definesPresentationContext = true
        
                //var titleNavBarButton = UIBarButtonItem(customview: searchBar)
                self.navigationItem.titleView = searchBar
        
        // set Default bar status.
        searchBar.searchBarStyle = UISearchBarStyle.default
        
                // change the color of cursol and cancel button.
                searchBar.tintColor = .black
        
            noAppointmentsTodayLabel.isHidden = true
            phoneButtonHeight.constant = 60
            phoneButton.layer.cornerRadius = phoneButton.bounds.height / 2 //frame.size.width
            phoneButton.clipsToBounds = true
            phoneButton.layer.borderWidth = 2.0
            phoneButton.layer.borderColor = UIColor.red.cgColor
            AddTaskButton.isHidden = true
            AddTaskButton.layer.cornerRadius = 5
        
            //1. Determine device Type and set alert & hamburger view offsets
            setHideAndShowOffsetFromDeviceType()
            //2. Move slide menues off screen
            moveSlideMenu(Menu: "hideHamburgerView")
            moveSlideMenu(Menu: "hideAlertView")
            //3. Cast shadow along slide out menu edge for 3D effect
            hamburgerContainerView.layer.shadowOpacity = 1
            alertContainerView.layer.shadowOpacity = 1
        //set date display text to current date. dateDisplayButton
            self.setCurrentDateInDefaults()
            let currentDateFromDefaults = UserDefaults.standard.string(forKey: "currentDate")
            self.dateDisplayButton.setTitle(currentDateFromDefaults, for: .normal)
        
        // White thin line [] | [] | [] between buttons
            pendingReferralsButton.layer.addBorder(edge: UIRectEdge.right, color: .white, thickness: 0.5)
            unreadMessagesButton.layer.addBorder(edge: UIRectEdge.left, color: .white, thickness: 0.5)
        // Orange line below number labels
            orangeLine1.layer.addBorder(edge: UIRectEdge.bottom, color: .orange, thickness: 2)
            orangeLine2.layer.addBorder(edge: UIRectEdge.bottom, color: .orange, thickness: 2)
            orangeLine3.layer.addBorder(edge: UIRectEdge.bottom, color: .orange, thickness: 2)
        
            dateDisplayButton.layer.cornerRadius = 5
        
            //leadingConstraintContainerView.constant = -270
        
        //Add BADGE to right bar button item in nav controller
            var alertCount = 0
            if isKeyPresentInUserDefaults(key: "alertCount") {
                alertCount = UserDefaults.standard.integer(forKey: "alertCount")
            }
            rightBarButtonAlert.addBadge(number: alertCount)//alertImageNames.count)
        
        //rightBarButtonAlert.updateBadge(number: 20) rightBarButtonAlert: UIBarButtonItem!
        
        // Get stored data
        if isKeyPresentInUserDefaults(key: "onlyDoOnce") { //does this exist? [yes]
            
            getUpdateAppointmentData()
            print("getUpdateAppointmentData")
            
        } else {//[no] does not exist
            setUpAppointmentData()
            print("setUpAppointmentData there is no key onlyDoOnce")
        }
        
        let inboxCount = UserDefaults.standard.integer(forKey: "inboxCount")
        unreadMessagesLabel.text = String(inboxCount)
        
        // check if section one 0[1]2 scheduled appointments is empty from updated stored data
        let numberOfAppointments = appPat[1].count
        if numberOfAppointments == 0 {
            noAppointmentsTodayLabel.isHidden = false
        }
        
        //reload table based on current date if a date was not selected from PICKER
        updateTableByDate(searchText: currentDateFromDefaults!)
        
        //Tap to Dismiss KEYBOARD
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
    }
    
    // This will hide keyboard when click off field or finished editing text field
//    func dismissKeyboard(){
//        view.endEditing(true)
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        //check if user is signed in ELSE go to Sign In View
        let isUserSignedIn = UserDefaults.standard.bool(forKey: "isUserSignedIn")
        if(!isUserSignedIn)
        {
            self.performSegue(withIdentifier: "ShowLogInView", sender: self)
        }
        
        // change navigation bar to custom color "fern"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0.27, green: 0.52, blue: 0.0, alpha: 1.0)
        
        //save appointments count, inbox patients count
        let numberNewPatients = (appPat[0].count)
        let numberScheduledPatients = (appPat[1].count)
        
        UserDefaults.standard.set(numberScheduledPatients, forKey: "numberScheduledPatients")
        //inbox needed
        UserDefaults.standard.set(numberNewPatients, forKey: "numberNewPatients")
        
        pendingPatientsLabel.text = "\(numberNewPatients)"
        scheduledAppointLabel.text = "\(numberScheduledPatients)"
        
    }
    
//    override func viewDidAppear( _ animated: Bool) {
//        
//        //check if user is signed in ELSE go to Sign In View
//        let isUserSignedIn = UserDefaults.standard.bool(forKey: "isUserSignedIn")
//        if(!isUserSignedIn)
//        {
//            self.performSegue(withIdentifier: "ShowLogInView", sender: self)
//        }
//        
//        // change navigation bar to custom color "fern"
//        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0.27, green: 0.52, blue: 0.0, alpha: 1.0)
//        
//        
//    }
    
    //
    // #MARK: - Button Actions
    //
    
    @IBAction func AddTaskButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ShowAddTaskView", sender: self)
    }
    
    @IBAction func dateDisplatButtonTapped(_ sender: Any) {
        showCalendarAlert()
    }
    

    @IBAction func callButtonTapped(_ sender: Any) {
        //UIApplication.shared.openURL(url) deprecieated in iOS 10
            open(scheme: "tel://8556235691")
    }
    
    
    @IBAction func hamburgerBarButtonTapped(_ sender: Any) {
        
        if(hamburgerMenuShowing) {//if showing hide menu
            //leadingConstraintContainerView.constant = -270
            moveSlideMenu(Menu: "hideHamburgerView")
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else {
            //leadingConstraintContainerView.constant = 0
            moveSlideMenu(Menu: "showHamburgerView")
            if(alertTableShowing){
                moveSlideMenu(Menu: "hideAlertView")
                alertTableShowing = !alertTableShowing
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        hamburgerMenuShowing = !hamburgerMenuShowing
    }
    @IBAction func hamburgerOutsideButtonTapped(_ sender: Any) {
        moveSlideMenu(Menu: "hideHamburgerView")
        hamburgerMenuShowing = !hamburgerMenuShowing
        hamburgerOutsideButton.isHidden = true
    }
    
    @IBAction func alertButtonTapped(_ sender: Any) {
        
        if(alertTableShowing) {//if alert showing then hide alert
            moveSlideMenu(Menu: "hideAlertView")
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else {
            moveSlideMenu(Menu: "showAlertView")
            if(hamburgerMenuShowing){
                moveSlideMenu(Menu: "hideHamburgerView")
                hamburgerMenuShowing = !hamburgerMenuShowing
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        alertTableShowing = !alertTableShowing
    }
    @IBAction func alertOutsideButtonTapped(_ sender: Any) {
        moveSlideMenu(Menu: "hideAlertView")
        alertTableShowing = !alertTableShowing
        alertOutsideButton.isHidden = true
    }
    
    
    
    //
    // #MARK: - Supporting Functions
    //
    
    @objc func updateAlertBadgeNumber(){//newNumber: Int) {
        let alertCount = UserDefaults.standard.integer(forKey: "alertCount")
        rightBarButtonAlert.updateBadge(number: alertCount)//newNumber) //rightBarButtonAlert: UIBarButtonItem!
        
    }
    
    func setHideAndShowOffsetFromDeviceType() {
        let model = UIDevice.current.modelSize //return device model size
        
        
        switch model {
        case 375:  /*  iPhone  */          alertOffset = 320
                                        hambuOffset = 320
                                        print("UIDevice current model is 375 'iPhone'")
        case 414:  /* iPhone + */          alertOffset = 358
                                        hambuOffset = 310
                                        //adjustPhoneButtonSizeForDeviceType(sideLength:60)
                                        print("UIDevice current model is 414 'iPhone+'")
        case 320:  /*   iPad   */          alertOffset = 710
                                        hambuOffset = 670
                                        //adjustPhoneButtonSizeForDeviceType(sideLength:70)
                                        print("UIDevice current model is 320 'ipad mini'")
        default: print("UIDevice current model not 375 'iPhone', 414 'iPhone+' or 320 'ipad mini'")
                        alertOffset = 0
                        hambuOffset = 0
        }
        
    }
    
//    func adjustPhoneButtonSizeForDeviceType(sideLength: CGFloat ) {
//        //phoneButton.layer.frame = CGRectMake(200, 200, 100, 100)
//        phoneButtonWidth.constant = sideLength
//        phoneButtonHeight.constant = sideLength
//    }
    
    func showCalendarAlert(){
        //var searchText = "2/14/17"
        
        DatePickerDialog().show("Appointment Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if date != nil {
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = DateFormatter.Style.short
                //dateFormat.timeStyle = DateFormatter.Style.short --NO TIME
                let strDate = dateFormat.string(for: date!)!
                //self.dateLabel.text = "\(strDate)"
                self.dateDisplayButton.setTitle(strDate, for: .normal)
                UserDefaults.standard.setValue(strDate ,forKey: "newDate")
                
                //----- UPDATE TABLE BY DATE SELECTED
                
                self.updateTableByDate(searchText: strDate)
                
                
                
                // IF table empty self.filteredDates.count == 0 DISPLAY No Appointments for this Day
                
            }
        }
        //Save new date to user defaults
        UserDefaults.standard.set(true, forKey: "didUpdateCalendarDate") //need check to display a date if no date selected
        
        //UPDATE TABLE FROM SQL DB      DBtime, DBpatient, DBtasks for a given DB date
        
            //check if appoints is empty appPat[1].count == 0
            //if not empty then filter appTime, appMessage and appPat by the given date
        
    }
    
    func updateTableByDate(searchText: String) {
    
        //searchText = strDate //This contains date selected "2/17/17"
        
        var integerArray:[Int] = []
    
        self.filteredDates = self.appDate[1].filter({ (text) -> Bool in
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
        for i in integerArray {
            if i != NSNotFound {
                //TEST print("match \(i),\(index)") //testing
                //add
                self.filteredTime.append(self.appTime[1][index-1])
                self.filteredPatient.append(self.appPat[1][index-1])
                self.filteredMessage.append(self.appMessage[1][index-1])
                self.filteredAppID.append(self.appID[1][index-1])
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
        
        print(self.filteredDates)
        
//        if(self.filteredDates.count == 0){
//            self.filterActive = false;
//        } else {
            self.filterActive = true;
        //}
        
        self.tasksTableView.reloadData()
    }
    
    func moveSlideMenu(Menu: String) {
        let alertMenuConstraint:CGFloat = alertOffset //710//358
        let hamburgerMenuConstraint:CGFloat = hambuOffset //670//310
    
        switch Menu {
        case "showHamburgerView":
            leadingConstraintContainerView.constant = 0
            //trailingConstraintHamburgerView.constant -= hamburgerMenuConstraint//270 iPhone 6, 310 for 6+
            hamburgerOutsideButton.isHidden=false
        case "hideHamburgerView":
            leadingConstraintContainerView.constant = -hamburgerMenuConstraint
            //trailingConstraintHamburgerView.constant += hamburgerMenuConstraint
            hamburgerOutsideButton.isHidden=true
        case "showAlertView":
            leadingConstraintContainerView2.constant -= alertMenuConstraint//320 for iPhone 6, 358 iPhone 6+
//            trailingConstraintAlertView.constant += alertMenuConstraint
            alertOutsideButton.isHidden = false
        case "hideAlertView":
            leadingConstraintContainerView2.constant += alertMenuConstraint
//            trailingConstraintAlertView.constant -= alertMenuConstraint
            alertOutsideButton.isHidden = true
        default:
            print("fail: openClose")
        }
    }
    
    //Supports CALL IBACTION
    func open(scheme: String) {
        //http://useyourloaf.com/blog/openurl-deprecated-in-ios10/
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
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

    func setUpAppointmentData(){
        
//        appID = appointmentIDs
//        appPat = patients
//        appTime = times
//        appDate = dates
//        appMessage = appointmentMessage
//        
//        //UserDefaults.standard.set(appSec, forKey: "appSec")
//        UserDefaults.standard.set(appID, forKey: "appID")
//        UserDefaults.standard.set(appPat, forKey: "appPat")
//        UserDefaults.standard.set(appTime, forKey: "appTime")
//        UserDefaults.standard.set(appDate, forKey: "appDate")
//        UserDefaults.standard.set(appMessage, forKey: "appMessage")
        
        self.setUpPatientDataInDefaults()
        getUpdateAppointmentData()
        //get whats in defaults
        let onlyDoOnceHere = 1//UserDefaults.standard.integer(forKey: "onlyDoOnce")
        
//        if isKeyPresentInUserDefaults(key: "onlyDoOnce") { //does exist? in defaults [yes]
//            
//            onlyDoOnceHere += 1
//            
//        } else {// [no]
//            
//            onlyDoOnceHere = 1
//            
//        }
        
        //update defaults with new integer
        UserDefaults.standard.set(onlyDoOnceHere, forKey: "onlyDoOnce")
        UserDefaults.standard.synchronize()
        
    }

    
    
    //
    // #MARK: - Search Functions
    //
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        searchBar.showsCancelButton = true
        searchBar.placeholder = ""
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Start Communication"
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        //alertSearchBar.endEditing(true)
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
        
        if(filterActive) {
            return filteredDates.count
        }
        
        return appPat[1].count//patients.count
        
    }
    
    //[3] RETURN actual CELL to be displayed
    
    // SHOW SEGUE ->
    // " 1. click cell drag to second view. select the “show” segue in the “Selection Segue” section. "
    //http://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
    func tableView(_ tableView: UITableView, cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "apptCell")! as! AppointmentCell
        cell.photo.image = UIImage(named: "green.circle.png")//photos[IndexPath.row]
        
        if(filterActive){
            //var filteredTime:[String] = []
            //var filteredPatient:[String] = []
            //var filteredMessage:[String] = []
            cell.task.text = filteredMessage[IndexPath.row]
            cell.patient.text = filteredPatient[IndexPath.row]
            cell.time.text = filteredTime[IndexPath.row]
        } else {
        
        cell.task.text = appMessage[1][IndexPath.row]//appointments[IndexPath.row]
        cell.patient.text = appPat[1][IndexPath.row]//patients[IndexPath.row]
        cell.time.text = appTime[1][IndexPath.row]//times[IndexPath.row]
            
        }
        cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addNoteCompletePatient" {
            
            let selectedRow = ((tasksTableView.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
            //let sectionOfSelectedRow = 1 //Accepted Patients
            let patientName = filteredPatient[selectedRow] //appPat[sectionOfSelectedRow][selectedRow]
            
            let filterAppointmentID = filteredAppID[selectedRow]
            UserDefaults.standard.set(filterAppointmentID, forKey: "filterAppointmentID")
            
            let accepted = 1
            
            UserDefaults.standard.set(patientName, forKey: "patientNameMainDashBoard")
            //UserDefaults.standard.set(selectedRow, forKey: "selectedRowMainDashBoard")
            
            UserDefaults.standard.set(selectedRow, forKey: "selectedRow")
            UserDefaults.standard.set(accepted, forKey: "sectionForSelectedRow")
            
            //UserDefaults.standard.set(sectionOfSelectedRow, forKey: "sectionOfSelectedRowMainDashBoard")
            
        }
        
    }
    
    
    
}



