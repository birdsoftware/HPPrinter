//
//  TasksViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 12/19/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var CareTeamPicker: UIPickerView!
    @IBOutlet weak var careTeamLabel: UILabel!

    
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
    
    //****** Care Team Picker *****//
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return careTeamList.count
    }
    // returns data to display in care team picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return careTeamList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        careTeamLabel.text = careTeamList[row]
        //pickerBizCat.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTasksButtonTapped(_ sender: Any) {
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
