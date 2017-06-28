//
//  Allergy.swift
//  CarePointe
//
//  Created by Brian Bird on 6/26/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class Allergy: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //label
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var severityLabel: UILabel!
    
    //UITextFields
    @IBOutlet weak var allergyName: UITextField!
    @IBOutlet weak var reaction: UITextField!
    
    //picker
    @IBOutlet weak var severityPicker: UIPickerView!
    
    //constraint
    @IBOutlet weak var severityPickerHeightConstraint: NSLayoutConstraint!
    
    var isQuantOpen = false
    var severity = ["Mild","Moderate","Severe"]
    
    //
    // MARK: - override functions
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Picker Delegates
        severityPicker.delegate = self
        severityPicker.dataSource = self
        
    }
    
    //
    // MARK: - Support Functions
    //
    func seguePatientTabBar(){
        self.performSegue(withIdentifier: "segueToPatientTabBarFromAddAllergy", sender: self)
    }
    
    //
    // MARK: - Buttons
    //
    @IBAction func backButtonAction(_ sender: Any) {
        seguePatientTabBar()
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        seguePatientTabBar()
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
    @IBAction func severityButtonAction(_ sender: Any) {
        togglePickerButton(isOpen: &isQuantOpen, hightPickerConstraint: severityPickerHeightConstraint)
    }
    
    
    //required in class
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // returns the number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return severity.count
    }
    // returns data to display  picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return severity[row]
    }
    // picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
            severityLabel.text = severity[row]
            togglePickerButton(isOpen: &isQuantOpen, hightPickerConstraint: severityPickerHeightConstraint)
    }
    
    func togglePickerButton(isOpen: inout Bool, hightPickerConstraint: NSLayoutConstraint){
        if isOpen {
            severityPickerHeightConstraint.constant -= 120
        } else {
            severityPickerHeightConstraint.constant += 120
        }
        isOpen = !isOpen
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
