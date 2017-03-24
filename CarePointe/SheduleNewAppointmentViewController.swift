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

    // Labels
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var patientMessage: UILabel!
    @IBOutlet weak var appointmentID: UILabel!  //  AppointmentID: 09871
    
    @IBOutlet weak var appointmentDateTime: UILabel!
    
    var appTime = [[String]]()
    var appDate = [[String]]()
    var appMessage = [[String]]()
    var selectedRow = Int()
    
    var strTime = String()
    var strDate = String()
    var didChangeDateAndTime =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appTimeT = UserDefaults.standard.object(forKey: "appTime")
        let appDateT = UserDefaults.standard.object(forKey: "appDate")
        let appMessageT = UserDefaults.standard.object(forKey: "appMessage")
        
        if let appTimeT = appTimeT {
            appTime = appTimeT as! [[String]]
        }
        
        if let appDateT = appDateT {
            appDate = appDateT as! [[String]]
        }
        
        if let appMessageT = appMessageT {
            appMessage = appMessageT as! [[String]]
        }
        
        //UI setup
        selectedRow = UserDefaults.standard.integer(forKey:"selectedRow")
        //let sectionForSelectedRow = UserDefaults.standard.string(forKey:"sectionForSelectedRow")

        
        let patient = UserDefaults.standard.string(forKey: "patientName")!
        let message = appMessage[0][selectedRow] //0 = new
        let appointment = UserDefaults.standard.string(forKey: "appointmentID")!
        let date = appDate[0][selectedRow]      //0 = new
        let time = appTime[0][selectedRow]      //0 = new about to send to 1 = accepted
        let strDateTime = date + ", " + time
        
        patientName.text = "Patient: " + patient
        patientMessage.text = message
        appointmentID.text = "  Appointment ID: " + appointment
        appointmentDateTime.text = "  Appointment Date, Time: \(strDateTime)"
    }

    
    //
    //#MARK -Button Actions
    //
    
    @IBAction func backButtonTapped(_ sender: Any) {
        //1. palce "@IBAction func unwind...(segue: UIStoryboardSegue) {}" in view controller you want to unwind too
        
        //2. In storyboard connect this view () -> to [exit]
        //   In storyboard set unwind segue identifier: "unwindToPatientDB"
        //                     Action: "unwind..."
        
        //3. Trigger unwind segue programmatically (below)
        
        self.performSegue(withIdentifier: "unwindToPatientDashboard", sender: self)
    }
    
    
    @IBAction func sendAppointmentButtonTapped(_ sender: Any) {
        
        //Update Date and time local data for new section
        if didChangeDateAndTime {
            self.changeDateTimeForThisAppointment(newTime: strTime, newDate: strDate, sectionNumber: 0)
            print("\(strDate) \(strTime)")
        }
        
        //save time and day for this patient
        // Move this New patient to Accepted (Move data from section 0 to section 1)
            let accepted = 1
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
                
                //SHOW Appointment date and Time in View UI
                    let dateTimeFormat = DateFormatter()
                    dateTimeFormat.dateStyle = DateFormatter.Style.short //"2/4/2017"
                    dateTimeFormat.timeStyle = DateFormatter.Style.short
                    let stringTimeDate = dateTimeFormat.string(for: dateAndTime!)!
                    self.appointmentDateTime.text = "  Appointment Date, Time: \(stringTimeDate)"
                
                //Save Appointment Date and Time locally
                    let timeFormat = DateFormatter()
                    timeFormat.timeStyle = DateFormatter.Style.short
                    self.strTime = timeFormat.string(for: dateAndTime!)!
                
                print("\(self.strTime)")
                
                    let dateFormat = DateFormatter()
                    dateFormat.dateStyle = DateFormatter.Style.short
                    self.strDate = dateFormat.string(from: dateAndTime!)
                
                print("\(self.strDate)")
                
                self.didChangeDateAndTime = true
            }
        }

        
    }
    
    
    func changeDateTimeForThisAppointment(newTime: String, newDate: String, sectionNumber: Int) {
        
        appDate[sectionNumber][selectedRow] = newDate
        appTime[sectionNumber][selectedRow] = newTime
        
        UserDefaults.standard.set(appTime, forKey: "appTime")
        UserDefaults.standard.set(appDate, forKey: "appDate")
        UserDefaults.standard.synchronize()
        
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
