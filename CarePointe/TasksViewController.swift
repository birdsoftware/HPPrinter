//
//  TasksViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 12/19/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//

import UIKit
import Foundation

class TasksViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var CareTeamPicker: UIPickerView!
    @IBOutlet weak var careTeamLabel: UILabel!
    @IBOutlet weak var newTaskDescription: UITextField!
    @IBOutlet weak var newTaskNote: UITextField!
    @IBOutlet weak var newTaskDateText: UITextField!

    
    var careTeamList = ["Global CSC", "Jannifer Johnson", "Admin", "Dr Gary", "Doctor on Wheels Inc"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CareTeamPicker.delegate = self
        CareTeamPicker.dataSource = self
        careTeamLabel.text = careTeamList[0]

        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func datePickerTapped(_ sender: Any) {
        // UIDatePickerMode? .date or .dateAndTime
        // https://developer.apple.com/reference/uikit/uidatepickermode
        DatePickerDialog().show("Task Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .dateAndTime) {
            (dateAndTime) -> Void in
            if dateAndTime != nil { 
                
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = DateFormatter.Style.short
                dateFormat.timeStyle = DateFormatter.Style.short
                
                let strDate = dateFormat.string(for: dateAndTime!)
                
                self.newTaskDateText.text = "\(strDate!)"
            }
        }
    }
    
    
    //
    // #MARK: - Picker View
    //
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // returns the number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(careTeamList.isEmpty == false){
            return careTeamList.count
        }
        else {
            return 0
        }
    }
    // returns data to display in care team picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return careTeamList[row]
    }
    // picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        careTeamLabel.text = careTeamList[row]
        //pickerBizCat.hidden = true;
    }
    
    //
    // #MARK: - Button Actions
    //
    
    @IBAction func addTasksButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowDashboardView", sender: self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowDashboardView", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
