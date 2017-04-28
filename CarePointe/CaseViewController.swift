//
//  EMRViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class CaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //segment controller
    @IBOutlet weak var caseSegmentControl: UISegmentedControl!
    
    //containers
    @IBOutlet weak var containerView1: UIView! //services
    @IBOutlet weak var containerView2: UIView! //locations
    
    //tabels
    @IBOutlet weak var caseTable: UITableView!
    @IBOutlet weak var clinicalTable: UITableView!
    
    let caseInfo = [["Start Date","02/02/2017"],
                   ["Program","Transitional Care"],
                   ["Disease","Fibromyalgia"],
                   ["Acuity","High"],
                   ["SNP","Caregiver, Supplies, Transportation"],
                   ["Summary","Patient came to us from Observation Unit at Chandler Regional Hospital. Patient had a few prior hospitalizations due to falls in the past weeks. Patient suffers from permanent brain damage due to traumatic car accident. Experiences access falls and confusion and needs 24hr monitoring. Lives with Husband and Daughter that act as caregivers."]
                   ]
    
    let clinicalData = [["ICD-10's","Dependence on Wheelchair"],
                        ["Symptoms","-"]
                        ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up UI
        containerView1.isHidden = true
        containerView2.isHidden = true
        
        //delegation
        caseTable.dataSource = self
        caseTable.delegate = self
        clinicalTable.dataSource = self
        clinicalTable.delegate = self
        
        caseTable.rowHeight = UITableViewAutomaticDimension
        caseTable.estimatedRowHeight = 150
        clinicalTable.rowHeight = UITableViewAutomaticDimension
        clinicalTable.estimatedRowHeight = 150
        
        // Setup sement control font and font size
        let attr = NSDictionary(object: UIFont(name: "Futura", size: 16.0)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
    }
    
    
    // Buttons
    
    @IBAction func feedsSegmentControllerTapped(_ sender: Any) {
    
        switch caseSegmentControl.selectedSegmentIndex
        {
        case 0:
            containerView1.isHidden = true
            containerView2.isHidden = true
        case 1:
            containerView1.isHidden = false
            containerView2.isHidden = true
        case 2:
            containerView1.isHidden = true
            containerView2.isHidden = false
        default:
            break;
        }
    }
    
    
    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == caseTable){
            
            if(caseInfo.isEmpty == false) { return caseInfo.count } else { return 0 }
            
        } else {
            if(clinicalData.isEmpty == false) { return clinicalData.count } else { return 0 }
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == caseTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "casecell") as! caseCell
            
            cell.label.text = caseInfo[IndexPath.row][0]
            cell.details.text = caseInfo[IndexPath.row][1]
            
            if(IndexPath.row % 2 == 0){
                cell.backgroundColor = UIColor.polar()  }
            else{
                cell.backgroundColor = UIColor.white  }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "clinicalcell") as! clinicalCell
            
            cell.label.text = clinicalData[IndexPath.row][0]
            cell.details.text = clinicalData[IndexPath.row][1]
            
            if(IndexPath.row % 2 == 0){
                cell.backgroundColor = UIColor.polar()  }
            else{
                cell.backgroundColor = UIColor.white  }
            
            return cell
        }
        
        
        
        
    }

    
    
}
