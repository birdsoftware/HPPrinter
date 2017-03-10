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
        
        vitals = [["Height","5ft 7 in"],
                        ["Weight","140 lbs"],
                        ["BMI","27.6"],
                        ["BMI Status","Obesity"],
                        ["Body Temperature","98.3 ℉"],
                        ["BP-Sitting Location","Left"],
                        ["BP-Sitting Sys/Dia","120/80"],
        ]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
