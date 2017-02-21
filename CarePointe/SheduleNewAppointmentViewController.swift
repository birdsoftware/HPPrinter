//
//  SheduleNewAppointmentViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/16/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class SheduleNewAppointmentViewController: UIViewController {

    @IBOutlet weak var sendAppointment: UIButton!
    @IBOutlet weak var changeDateButton: UIButton!

    
    @IBOutlet weak var appointmentDateTime: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UI setup
    }

    
    //
    //#MARK -Button Actions
    //
    
    @IBAction func sendAppointmentButtonTapped(_ sender: Any) {
        
        //save time and day for this patient
        // Move this New patient to Accepted
        let accepted = 1
        //self.movePatientToSection(SectionNumber: accepted)
        self.moveAppointmentToSection(SectionNumber: accepted)
        
        //SHOW TOAST
        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
            
            //if you perform segue here if will perform with animation
            self.view.makeToast("Appointment Set", duration: 1.1, position: .center)
        }, completion: { finished in
            
            // Instantiate a view controller from Storyboard and present it
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
            self.present(vc, animated: false, completion: nil)
            
            
        })
        
    }
    
    
    @IBAction func selectDateAndTimeButtonTapped(_ sender: Any) {
        
 
        // https://developer.apple.com/reference/uikit/uidatepickermode
        DatePickerDialog().show("Appointment Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .dateAndTime) {
            (dateAndTime) -> Void in
            if dateAndTime != nil {
                
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = DateFormatter.Style.short
                dateFormat.timeStyle = DateFormatter.Style.short
                
                let strDate = dateFormat.string(for: dateAndTime!)
                
                self.appointmentDateTime.text = "  Appointment Date, Time: \(strDate!)"
            }
        }

        
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
