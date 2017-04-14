//
//  VitalsContainer2VC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/8/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class VitalsContainer2VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var vitalsTable: UITableView!
    
    
    var vitals = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //delegation
        vitalsTable.delegate = self
        vitalsTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        vitalsTable.rowHeight = UITableViewAutomaticDimension
        vitalsTable.estimatedRowHeight = 150
        
        vitals = [["Height ft/in","5ft 7 in"],
                        ["Weight lbs","140 lbs"],
                        ["BMI","27.6"],
                        ["BMI Status","Obesity"],
                        ["Body Temperature ℉","98.3 ℉"],
                        ["BP-Sitting Location","Left"],
                        ["BP-Sitting Sys/Dia","120/80"],
        ]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // #MARK: - Button Action
    //
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        // Show Alert, get new vitals[n] text, show [Update] [Cancel] buttons
        let alert = UIAlertController(title: "Patient Vitals",
                                      message: "Update patient vitals",
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Update now", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let heightTextField = alert.textFields![0].text!
            let weightTextField = alert.textFields![1].text! //print(textField)
            let bmiTextField = alert.textFields![2].text!
            let bmiStatusTextField = alert.textFields![3].text!
            let bodyTempTextField = alert.textFields![4].text!
            let bpLocationTextField = alert.textFields![5].text!
            let bpTextField = alert.textFields![6].text!
            
            //check for empty fields
            if (heightTextField.isEmpty == false) {
                self.vitals[0][1] = heightTextField//.text!
            }
            if (weightTextField.isEmpty == false) {
                self.vitals[1][1] = weightTextField//.text!
            }
            if (bmiTextField.isEmpty == false) {
                self.vitals[2][1] = bmiTextField//.text!
            }
            if (bmiStatusTextField.isEmpty == false) {
                self.vitals[3][1] = bmiStatusTextField//.text!
            }
            if (bodyTempTextField.isEmpty == false) {
                self.vitals[4][1] = bodyTempTextField//.text!
            }
            if (bpLocationTextField.isEmpty == false) {
                self.vitals[5][1] = bpLocationTextField//.text!
            }
            if (bpTextField.isEmpty == false) {
                self.vitals[6][1] = bpTextField//.text!
            }
            
            self.vitalsTable.reloadData()
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // Add Height textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New Height ft/in"
            textField.clearButtonMode = .whileEditing
            
        }
        // Add Weight textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New Weight lbs"
            textField.clearButtonMode = .whileEditing
            
        }
        // Add BMI textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New BMI"
            textField.clearButtonMode = .whileEditing
        }
        // Add BMI Status textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New BMI Status"
            textField.clearButtonMode = .whileEditing
        }
        // Add Body Temperature textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New Body Temperature ℉"
            textField.clearButtonMode = .whileEditing
        }
        // Add textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New BP-Sitting Location"
            textField.clearButtonMode = .whileEditing
        }
        // Add textField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "New BP-Sitting Sys/Dia"
            textField.clearButtonMode = .whileEditing
        }
        
        //let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 1.80)
       // alert.view.addConstraint(height)
        
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vitals.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vitals") as! vitalsCell
        
        cell.label.text = vitals[IndexPath.row][0]
        cell.details.text = vitals[IndexPath.row][1]
        
        if(IndexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.polar()  }
        else{
            cell.backgroundColor = UIColor.white  }
        
        return cell
    }
    
    
    
    
    
}
