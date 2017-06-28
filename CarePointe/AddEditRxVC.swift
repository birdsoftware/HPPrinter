//
//  AddEditRxVC.swift
//  CarePointe
//
//  Created by Brian Bird on 6/14/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class AddEditRxVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    //tableMeds
    @IBOutlet weak var medTable: UITableView!
    
    //view
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    //search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    //pickers
    @IBOutlet weak var quantityPicker: UIPickerView!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var routePicker: UIPickerView!
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var refillPicker: UIPickerView!
    @IBOutlet weak var selectPicker: UIPickerView!
    
    //labels
    @IBOutlet weak var quantLabel: UILabel!
    @IBOutlet weak var freqLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var refilLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var medicationsCountLabel: UILabel!
    @IBOutlet weak var medSelectionLabel: UILabel!
    
    //constraints
    @IBOutlet weak var quantPickerConstraint: NSLayoutConstraint!
    @IBOutlet weak var freqPickerConstraint: NSLayoutConstraint!
    @IBOutlet weak var routePickerConstraint: NSLayoutConstraint!
    @IBOutlet weak var unitPickerConstraint: NSLayoutConstraint!
    @IBOutlet weak var refillPickerConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectPickerConstraint: NSLayoutConstraint!
    @IBOutlet weak var medTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var medTableAndQuantButton: NSLayoutConstraint!
    
    //bools
    var isQuantOpen = false
    var isFreqOpen = false
    var isRouteOpen = false
    var isUnitOpen = false
    var isRefillOpen = false
    var isSelectOpen = false
    
    //search data
    var searchActive : Bool = false
    
    //picker data
    
    var medications = ["medId":"6591","medName":"1 25 dihydroxycholecalciferol"]
    
    var quantity = ["-","1","2","3","4","5","6","7","8","9","10","11","12"]
    var frequency = ["-","2 Times Weekly","3 Times Weekly","as directed","BID","Daily","Every Other Day",
                     "in A.M.","Nightly","Once a month","Q12h","Q1h WA","Q1wk","Q2h","Q2h WA","Q2hwks",
                     "Q3h","Q3wks","Q4-6h","Q48h","Q4h","Q6-8h","Q6h","Q72h","Q8-12h","Q8h","QHS","QID","TID"]

    var route = ["-","as directed","by mouth","ear, left","ear, right","ears, both","epidural", "eye, left", "eye, right",
                "eye, surgical","eyelids, apply to","eyes, both","face, apply to","face, thin layer to",
                "feeding tube,via","in vitro","inhale","inject, intramuscular","intraarticular",
                "intraocular","intraperitoneal","intrapleural","intrauterine","intravenous","intravesical",
                "lip, under the","nail, apply to","nose, in the","penis, inject into","perfusion",
                "rectum, in the","rinse","scalp, apply to","skin, apply to","skin, inject below","skin, inject into",
                "teeth, apply to","tongue, on the","tongue, under the","uretha, in the","vagina, in the"]
    
    var unit = ["-","Ampule","Applicator","Applicatorful","Bag","Bar","Bead","Blister","Blister Pack","Block","Bolus","Bottle",
                "Box","Can","Canister","Capsule","Caplet","Carton","Cartridge","Case","Cassette","Cello Pack","Clinical Units",
                "Coat","Container","Count","Cup","Cubic Inch","Curie","Cylinder","Dewar","Device","Dialpack","Disk",
                "Dose Pack","Drop","Drops","Drum","Dual Pack","Each","Film","Feet, Cubic","Feet, Square","Fluid Dram",
                "Fluid Ounce","Focus-Forming Units","Gallon","Generator","Globule","Gram","Grain","Hour","Homeopathic Dilution",
                "Implant","Inch","International Unit","Intravenous Bag","Jar","Jug","Kilogram","Kit","Lancet","Liter",
                "Lozenge","Microcurie","Microgram","Microliter","Micromole","Micromolar","Micron","Milliequivalent",
                "Millicurie","Milligram","Milliliter","Millimeter","Millimole","Million Units","Minim","Molar",
                "Mole","Nanogram","Nebule","Needle Fee Injection","Normal","Not Applicable","Ocular System","Ounce",
                "Package","Packet","Part Per Million","Paper","Pad","Pail","Parts","Patch","Pellete","Percent",
                "Percent Volume/Volume","Percent Weight/Volume","Percent Weight/Weight","Piece","Pint","Pouch","Pound",
                "Potency Not Given","Pressor Units","Protein Unit","Pen Needle","Pump","Puff","Quantity Sufficient",
                "Quart","Ring","Saturated","Sachet","Scoopful","Sponge","Spray","Square Centimeter","Square Yard",
                "Stick","Strip","Supersack","Suppository","Swab","Syringe","Tablet","Tablespoon","Teaspoon","Tabminder",
                "Tank","Tissue Culture Infectious Dose 50%","Trace","Tray","Troche","Ton","Tube","Units",
                "United States Pharmacopeia Unit","Unassigned","Unspecified","Vial","Wafer","Yard"]
    
    var refill = ["-","0","1","2","3","4","5","6","7","8","9","10","11","12"]
    var select = ["-","Dispense as written","Substitution Allowed"]
    
    //search table data
    var tableMeds = Array<Dictionary<String,String>>() //all from json
    var searchData = Array<Dictionary<String,String>>()
    
    //segue Data from Container1ViewController
    var segueMedication: String!
    var segueDosage: String!
    var segueFrequency: String!
    var segueRoute: String!
    var segueUnits: String!
    var segueRefillcount: String!
    
    //
    // MARK: - override functions
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Picker Delegates
        quantityPicker.delegate = self
        quantityPicker.dataSource = self
        frequencyPicker.delegate = self
        frequencyPicker.dataSource = self
        routePicker.delegate = self
        routePicker.dataSource = self
        unitPicker.delegate = self
        unitPicker.dataSource = self
        refillPicker.delegate = self
        refillPicker.dataSource = self
        selectPicker.delegate = self
        selectPicker.dataSource = self
        
        //search delegate
        searchBar.delegate = self
        
        //table view delegate
        medTable.delegate = self
        medTable.dataSource = self
        
        medTable.rowHeight = UITableViewAutomaticDimension
        medTable.estimatedRowHeight = 60
        
        // UI Setup
        buttonView.backgroundColor = UIColor.Iron().withAlphaComponent(0.5)
        
        //Constraints
        quantPickerConstraint.constant = 0
        freqPickerConstraint.constant = 0
        routePickerConstraint.constant = 0
        unitPickerConstraint.constant = 0
        refillPickerConstraint.constant = 0
        selectPickerConstraint.constant = 0
        
        medTableAndQuantButton.constant = 0
        
        dateLabel.text = "Date: " + returnCurrentDateOrCurrentTime(timeOnly: false)
        
        //searchBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.ifEditSegueRefreshValues()
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                /*let json:[[String : String]]*/ self.tableMeds = loadJSON(name: "tbl_medications (1)")! //{"drugId":"17012","drugName":"ABIRATERONE"}
                print(self.tableMeds.count)
                //self.loadingView.isHidden = true
                self.loadingView.removeFromSuperview()
                
            }
        }
    }
    
    //
    // MARK: - Support Functions
    //
    func ifEditSegueRefreshValues(){
        
        if segueMedication != "" {
            medTableAndQuantButton.constant = 50
            medSelectionLabel.text = segueMedication
            
            quantLabel.text = segueDosage
            freqLabel.text = segueFrequency
            routeLabel.text = segueRoute
            unitLabel.text = segueUnits
            refilLabel.text = segueRefillcount
        }
    }
    func seguePatientTabBar(){
        self.performSegue(withIdentifier: "segueToPatientTabBarFromAddMed", sender: self)
    }
    
    //
    // MARK: - Buttons
    //
    @IBAction func quantButton(_ sender: Any) {
        togglePickerButton(isOpen: &isQuantOpen, hightPickerConstraint: quantPickerConstraint)
    }
    @IBAction func freqButtonTapped(_ sender: Any) {
        togglePickerButton(isOpen: &isFreqOpen, hightPickerConstraint: freqPickerConstraint)
    }
    @IBAction func routButtonTapped(_ sender: Any) {
        togglePickerButton(isOpen: &isRouteOpen, hightPickerConstraint: routePickerConstraint)
    }
    @IBAction func unitButtonTapped(_ sender: Any) {
        togglePickerButton(isOpen: &isUnitOpen, hightPickerConstraint: unitPickerConstraint)
    }
    @IBAction func refillButtonTapped(_ sender: Any) {
        togglePickerButton(isOpen: &isRefillOpen, hightPickerConstraint: refillPickerConstraint)
    }
    @IBAction func selectButtonTapped(_ sender: Any) {
        togglePickerButton(isOpen: &isSelectOpen, hightPickerConstraint: selectPickerConstraint)
    }
    @IBAction func changeDateButtonAction(_ sender: Any) {
        
        //var searchText = "2/14/17"
        
        DatePickerDialog().show("Appointment Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if date != nil {
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = DateFormatter.Style.short // --NO TIME .short
                let strDate = dateFormat.string(for: date!)!
                
                //----- UPDATE UI LABEL BY DATE SELECTED ---------
                self.dateLabel.text = "Date: \(strDate)"
            }
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        seguePatientTabBar()
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        //save changes to cloud
        seguePatientTabBar()
    }
    
    
    //
    // #MARK: - Search Functions
    //
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let drugNamePredicate = NSPredicate(format: "SELF.drugName CONTAINS[cd] %@", searchText)
        
        let arr=(/*ScopeData*/ tableMeds as NSArray).filtered(using: drugNamePredicate)
        
        if arr.count > 0
        {
            searchData=arr as! Array<Dictionary<String,String>>
            //print("medications search count: \(searchData.count)")
            medicationsCountLabel.text = "Search result: \(searchData.count)"
            
        }
        
        if searchData.count < 2000 {
            
            medTable.reloadData()
            medTableHeightConstraint.constant = 250
            
        } else {
            
            searchData.removeAll()
            medTable.reloadData()
            medicationsCountLabel.text = "Search result: \(searchData.count)"
            
        }
        
        
        //let patientCount = searchData.count
        //myPatientsLabel.text = "My Patients (\(patientCount))"
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        medTableHeightConstraint.constant = 0
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { //need delegation
        searchActive = false
        searchBar.text = ""
        searchBar.endEditing(true)
        
        medicationsCountLabel.text = ""
        medTableHeightConstraint.constant = 0
        
        //SearchData=patientData
        //patientTable.reloadData()
        
        //let patientCount = patientData.count//ScopeData.count
        //myPatientsLabel.text = "My Patients (\(patientCount))"
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    
    //
    // #MARK: - Picker View
    //

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // returns the number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == quantityPicker { return quantity.count }
        if pickerView == frequencyPicker{ return frequency.count }
        if pickerView == routePicker { return route.count }
        if pickerView == unitPicker { return unit.count }
        if pickerView == refillPicker { return refill.count }
        else { return select.count }
    }
    // returns data to display in care team picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == quantityPicker { return quantity[row] }
        if pickerView == frequencyPicker{ return frequency[row] }
        if pickerView == routePicker { return route[row] }
        if pickerView == unitPicker { return unit[row] }
        if pickerView == refillPicker { return refill[row] }
        else { return select[row] }
        
    }
    // picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if pickerView == quantityPicker {
            quantLabel.text = quantity[row]
            togglePickerButton(isOpen: &isQuantOpen, hightPickerConstraint: quantPickerConstraint)
        }
        if pickerView == frequencyPicker{
            freqLabel.text = frequency[row]
            togglePickerButton(isOpen: &isFreqOpen, hightPickerConstraint: freqPickerConstraint)
        }
        if pickerView == routePicker {
            routeLabel.text = route[row]
            togglePickerButton(isOpen: &isRouteOpen, hightPickerConstraint: routePickerConstraint)
        }
        if pickerView == unitPicker {
            unitLabel.text = unit[row]
            togglePickerButton(isOpen: &isUnitOpen, hightPickerConstraint: unitPickerConstraint)
        }
        if pickerView == refillPicker {
            refilLabel.text = refill[row]
            togglePickerButton(isOpen: &isRefillOpen, hightPickerConstraint: refillPickerConstraint)
        }
        if pickerView == selectPicker {
            selectLabel.text = select[row]
            togglePickerButton(isOpen: &isSelectOpen, hightPickerConstraint: selectPickerConstraint)
        }
        
    }
    
    func togglePickerButton(isOpen: inout Bool, hightPickerConstraint: NSLayoutConstraint){
        if isOpen {
            hightPickerConstraint.constant -= 200
        } else {
            hightPickerConstraint.constant += 200
        }
        isOpen = !isOpen
    }

    
    //
    // #MARK: - Table View
    //
    
    //return number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchData.isEmpty == false){
            return searchData.count
        }
        else {
            return 0
        }
    }
    
    //return actual CELL to be displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "medicationcell") as! MedCell
        
        var Data:Dictionary<String,String> = searchData[indexPath.row]
        
        cell.medication.text = Data["drugName"]
        
        return cell
    }
    
    // select a medication show it medTableAndQuantButton.const = 50
    //medSelectionLabel.text = selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        var selectedData:Dictionary<String,String> = searchData[indexPath.row]
        let drugName = selectedData["drugName"]!
        medSelectionLabel.text = drugName
        
        //clean up after selection. hide keyboard, clear search bar etc
        searchActive = false
        searchBar.text = ""
        searchBar.endEditing(true)
        
        medicationsCountLabel.text = ""
        medTableHeightConstraint.constant = 0
        
        medTableAndQuantButton.constant = 50
        
    }

    //
    // MARK: - Navigation
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let pvc = segue.destination as? PatientTabBarController {
            
            pvc.segueSelectedIndex = 3 //0 Feed, 1 Case, 2 Patient, 3 Rx and 4 Forms
            
        }
        
    }
    

}
