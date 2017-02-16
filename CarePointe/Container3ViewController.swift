//
//  Container3ViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class Container3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //table view
    
    @IBOutlet weak var allergyTableView: UITableView!
    
    var allergyData = [
        
        ["41-Barbiturates","fever","Mild","01/18/2013"],
        ["245-Penicillin","Rash","Low","01/03/2016"],
        ["412-Shrimp","swelling","Mild","11/01/1995"]
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegation
        allergyTableView.delegate = self
        allergyTableView.dataSource = self
        allergyTableView.estimatedRowHeight = 100
    }
    
    //1 return # sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //2 return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rxcontainer3Cell", for: indexPath) as! RxContainer3Cell
        
        cell.allergy.text = allergyData[indexPath.row][0]
        cell.reaction.text = allergyData[indexPath.row][1]
        cell.severity.text = allergyData[indexPath.row][2]
        cell.dateRecognized.text = allergyData[indexPath.row][3]
        
        return cell
    }
    
    //DELETE row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            allergyData.remove(at: (indexPath as NSIndexPath).row)
            allergyTableView.reloadData()
        }
    }
}
