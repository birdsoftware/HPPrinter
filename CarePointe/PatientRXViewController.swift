//
//  PatientRXViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientRXViewController: UIViewController {
    
    
    @IBOutlet weak var medRecButton: RoundedButton!
    //@IBOutlet weak var updateMedRecButton: BorderedButton!
    @IBOutlet weak var medicationSegmentor: UISegmentedControl!
    
    //views
    @IBOutlet weak var containerView1: UIView!//med list
    @IBOutlet weak var containerView2: UIView!//questionnaire
    @IBOutlet weak var containerView3: UIView!//allergies
    @IBOutlet weak var containerView4: UIView!//rx files
    
    @IBOutlet var mainView: UIView!
    
    
    @IBOutlet weak var drugToDrugView: UIView!
    @IBOutlet weak var topDrugToDrug: NSLayoutConstraint!
    
    //labels
    @IBOutlet weak var patientTitle: UILabel!
    
    //@IBOutlet weak var drugToDrugHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var drugToDrugUIView: UIView!
    var verticalConstraint:NSLayoutConstraint!
    var horizontalConstraint:NSLayoutConstraint!
    var offSet1:CGFloat = 0.0
    var offSet2:CGFloat = 0.0
    var bottomHeight:CGFloat = 467.0
    var topHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // show patient Name in title
        bottomHeight = mainView.bounds.size.height-260//setBottumHeightBasedOnDeviceType() //bottumHeigh used in drags
        
        
        //var attributes = NSDictionary(object: UIFont(name: "System", size: 14.0)!, forKey: NSFontAttributeName as NSCopying)
        //medicationSegmentor.setTitleTextAttributes(attributes as! [AnyHashable : Any], for: .normal)
        
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        patientTitle.text = patientName! + "'s Rx"
        
        // update UI elements
        //updateMedRecButton.layer.cornerRadius = updateMedRecButton.frame.size.width / 2
        //updateMedRecButton.clipsToBounds = true
        containerView1.isHidden = false
        containerView2.isHidden = true
        containerView3.isHidden = true
        containerView4.isHidden = true
        
        let drags = UIPanGestureRecognizer(target: self, action: #selector(drag))
        
        
        drugToDrugUIView.addGestureRecognizer(drags)
        topDrugToDrug.constant = bottomHeight
    }
    
    @objc func drag(gest:UIPanGestureRecognizer) {
        view.layoutIfNeeded()
        
        let translation = gest.translation(in: self.view)
        switch (gest.state) {
        case .began:
            offSet1 = topDrugToDrug.constant //offSet = CGPoint(x: horizontalConstraint.constant, y: verticalConstraint.constant)
            break;
            
        case .changed:
            offSet2 = offSet1 - translation.y
            if(offSet1 < offSet2){
            topDrugToDrug.constant = topHeight//offSet - translation.y
            } else {
                topDrugToDrug.constant = bottomHeight
            }
            //print(topDrugToDrug.constant)
            view.layoutIfNeeded()
            break;
            
            
        case .ended:
            break;
            
        default:
            break;
        }
        
    }
    
    func setBottumHeightBasedOnDeviceType() -> CGFloat{
        let model = UIDevice.current.modelSize //return device model size
        
        var heightBottum:CGFloat = 0
        
        switch model {
        case 375:  /*  iPhone  */          heightBottum = mainView.bounds.size.height-260//400.0
                                        topHeight = -100.0
        case 414:  /* iPhone + */          heightBottum = mainView.bounds.size.height-260//477.0
        
        case 320:  /*   iPad   */          heightBottum = 477.0

        default: print("UIDevice current model not 375 'iPhone', 414 'iPhone+' or 320 'ipad mini'")
        heightBottum = 467.0
        }
        
        return heightBottum
    }
    
    // UI Segment Control
    
    @IBAction func medicationSelectorTapped(_ sender: Any) {
        //http://stackoverflow.com/questions/27956353/swift-segmented-control-switch-multiple-views
        switch medicationSegmentor.selectedSegmentIndex
        {
        case 0:
            medRecButton.isHidden = false
            medRecButton.setTitle("Add Medication", for: .normal)
            containerView1.isHidden = false
            containerView2.isHidden = true
            containerView3.isHidden = true
            containerView4.isHidden = true
        case 1:
            medRecButton.isHidden = true
            containerView1.isHidden = true
            containerView2.isHidden = false
            containerView3.isHidden = true
            containerView4.isHidden = true
        case 2:
            medRecButton.isHidden = false
            medRecButton.setTitle("Add Allergy", for: .normal)
            containerView1.isHidden = true
            containerView2.isHidden = true
            containerView3.isHidden = false
            containerView4.isHidden = true
        case 3:
            medRecButton.isHidden = true
            containerView1.isHidden = true
            containerView2.isHidden = true
            containerView3.isHidden = true
            containerView4.isHidden = false
        default:
            break;
        }
    }
    
    
    //
    // #MARK: - Buttons
    //
    @IBAction func backButtonTapped(_ sender: Any) {
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "PatientList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientListView") as UIViewController
        //vc.navigationController?.pushViewController(vc, animated: false)
        self.present(vc, animated: false, completion: nil)
        
    }
    @IBAction func AddMedButtonAction(_ sender: Any) {
        
        switch medicationSegmentor.selectedSegmentIndex
                {
                case 0:
                    //Med List
                    self.performSegue(withIdentifier: "RxToAddEditRx", sender: self)
                case 1:
                    //Questionnaire
                    break;
                case 2:
                    //Allergy
                    self.performSegue(withIdentifier: "RxToAddEditAllergy", sender: self)
                default:
                    break;
                }
    }
    
    
    
    
//    @IBAction func addRxButtonTapped(_ sender: Any) {
//        switch medicationSegmentor.selectedSegmentIndex
//        {
//        case 0:
//            showAddMedicationAlert()
//        case 1:
//            showAddMedRecAlert()
//        case 2:
//            showAddAllergyAlert()
//        default:
//            break;
//        }
//    }
    
//    func showAddMedRecAlert() {
//        let patientName = UserDefaults.standard.string(forKey: "patientName")
//        
//        // show Alert, ask why, get leave a note text, show [Submit] [Cancel] buttons
//        let alert = UIAlertController(title: patientName! + "'s Med Rec",
//                                      message: "Current ",
//                                      preferredStyle: .alert)
//        
//        // Submit button
//        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
//            // Get 1st TextField's text
//            let textField = alert.textFields![0]
//            
//            print(textField.text!)
//            
//            
//            // Instantiate a view controller from Storyboard and present it
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "PTV") as UIViewController
//            self.present(vc, animated: false, completion: nil)
//        })
//        
//        // Cancel button
//        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
//        
//        // Add 1 textField and customize it
//        alert.addTextField { (textField: UITextField) in
//            textField.keyboardAppearance = .dark
//            textField.keyboardType = .default
//            textField.autocorrectionType = .default
//            textField.placeholder = "Reason for declining this patient?"
//            textField.clearButtonMode = .whileEditing
//        }
//        
//        // Add action buttons and present the Alert
//        alert.addAction(submitAction)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)
//    }

}
