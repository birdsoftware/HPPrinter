//
//  Container1ViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class Container1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //table view
    @IBOutlet weak var medicationTableView: UITableView!
    
    var medicationData = [
        ["OXYCODONE","1","once a day","oral"],
        ["15827-CIMEDINE","1","once a day","oral"],
        ["Optium Test strips","2","once a day","2"],
        ["Refresh Celluvisc asiac 1% eye gel solution in a dropperette wash out assembly","3","Twice weekly","3"],
        ["Folgard RX 2.2 mg-25 mg-1 mg tablet","2","2","oral"],
        ["Procrit 400 mg","1","once a week","injection"],
        ["Prozac RX 0.2 mg-15 mg-1 mg tablet","0.5","2","oral"],
        ["AMOXIZYMPHACOL STEROID 47 mg","1","bi-weekly","injection"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegation
        medicationTableView.delegate = self
        medicationTableView.dataSource = self
        
        //auto resize table height (grow with more content)
        medicationTableView.rowHeight = UITableViewAutomaticDimension
        medicationTableView.estimatedRowHeight = 100
    }
    
    //
    // #MARK: - Table View
    //
    
    //1 return # sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //2 return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rxcontainer1Cell", for: indexPath) as! RxContainer1Cell
        
        cell.medicationTitle.text = medicationData[indexPath.row][0]
        cell.dosage.text = medicationData[indexPath.row][1]
        cell.frequency.text = medicationData[indexPath.row][2]
        cell.route.text = medicationData[indexPath.row][3]
        
        return cell
    }
    
//    //DELETE row
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            
//            medicationData.remove(at: (indexPath as NSIndexPath).row)
//            medicationTableView.reloadData()
//        }
//    }
    
}
