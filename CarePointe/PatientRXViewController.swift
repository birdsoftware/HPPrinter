//
//  PatientRXViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientRXViewController: UIViewController {
    
    @IBOutlet weak var updateMedRecButton: UIButton!
    @IBOutlet weak var medicationSegmentor: UISegmentedControl!
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var containerView2: UIView!
    @IBOutlet weak var containerView3: UIView!
    @IBOutlet weak var patientTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // show patient Name in title
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        patientTitle.text = patientName! + "'s Rx"
        
        // update UI elements
        updateMedRecButton.layer.cornerRadius = updateMedRecButton.frame.size.width / 2
        updateMedRecButton.clipsToBounds = true
        containerView1.isHidden = false
        containerView2.isHidden = true
        containerView3.isHidden = true
    }
    
    // UI Segment Control
    
    @IBAction func medicationSelectorTapped(_ sender: Any) {
        //http://stackoverflow.com/questions/27956353/swift-segmented-control-switch-multiple-views
        switch medicationSegmentor.selectedSegmentIndex
        {
        case 0:
            //updateMedRecButton.setTitle("+M", for: .normal)
            //
            containerView1.isHidden = false
            containerView2.isHidden = true
            containerView3.isHidden = true
        case 1:
            //updateMedRecButton.setTitle("+MR", for: .normal)
            containerView1.isHidden = true
            containerView2.isHidden = false
            containerView3.isHidden = true
        case 2:
            //updateMedRecButton.setTitle("+A", for: .normal)
            containerView1.isHidden = true
            containerView2.isHidden = true
            containerView3.isHidden = false
        default:
            break;
        }
    }
    
    
    //
    // #MARK: - Buttons
    //
    
    @IBAction func addRxButtonTapped(_ sender: Any) {
        switch medicationSegmentor.selectedSegmentIndex
        {
        case 0:
            showAddMedicationAlert()
        case 1:
            showAddMedRecAlert()
        case 2:
            showAddAllergyAlert()
        default:
            break;
        }
    }
    
    
    func showAddMedicationAlert() {
        
    }
    
    func showAddMedRecAlert() {
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        
        // show Alert, ask why, get leave a note text, show [Submit] [Cancel] buttons
        let alert = UIAlertController(title: patientName! + "'s Med Rec",
                                      message: "Current ",
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            
            print(textField.text!)
            
            
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
    
    func showAddAllergyAlert() {
        
    }
}
