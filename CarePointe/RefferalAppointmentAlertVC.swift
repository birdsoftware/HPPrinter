//
//  RefferalAppointmentAlertVC.swift
//  CarePointe
//
//  Created by Brian Bird on 5/2/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

class ReferralsAlertsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var apptLenPicker: UIPickerView!
    
    var lenTimes = ["15 min", "30 min", "45 min", "60 min", "2 hours", "3 hours"]
    var segueLenTimesLocal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        apptLenPicker.delegate = self
        apptLenPicker.dataSource = self
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // returns the number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
            
            return lenTimes.count
        
    }
    // returns data to display in picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

            return lenTimes[row]
        
    }
    // picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
            segueLenTimesLocal = lenTimes[row]
        
    }

    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        //performSegue(withIdentifier: "AlertToReferral", sender: nil)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        
        
        performSegue(withIdentifier: "AlertToReferral", sender: nil)
       
    }
    
    //AlertToReferral
    //segueLenTimes
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "AlertToReferral" {//this is the going back to the main dashboard
//            
//            if let toViewController = segue.destination as? ReferralsVC {
//                
//                //toViewController.segueLenTimes = segueLenTimesLocal
//                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLength"), object: nil)
//            }
//        }
//    }
    
}
