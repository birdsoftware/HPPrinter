//
//  ApptContainer3VC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/8/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class ApptContainer3VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //tables
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var historyTable: UITableView!

    
    var details = [[String]]()
    var history = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        details = [["Label 1","Appointment detail 1"],
                  ["Label 2","Appointment detail 2"],
                  ["Label 3","Appointment detail 3"],
                  ["Label 4","Appointment detail 4"],
                  ["Label 5","Appointment detail 5"],
                  ["Label 6","Appointment detail 6"],
                  ["Label 7","Appointment detail 7"],
        ]
        
        history = [["Label 1","History detail 1"],
                   ["Label 2","History detail 2"],
                   ["Label 3","History detail 3"],
                   ["Label 4","History detail 4"],
                   ["Label 5","History detail 5"],
                   ["Label 6","History detail 6"],
                   ["Label 7","History detail 7"],
        ]
        
        //delegation
        detailsTable.delegate = self
        detailsTable.dataSource = self
        historyTable.delegate = self
        historyTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        detailsTable.rowHeight = UITableViewAutomaticDimension
        detailsTable.estimatedRowHeight = 150
        historyTable.rowHeight = UITableViewAutomaticDimension
        historyTable.estimatedRowHeight = 150
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == detailsTable){
            return details.count
        } else {
            return history.count
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == detailsTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentdetailscell") as! AppointmentDetailsCell
            
            cell.label.text = details[IndexPath.row][0]
            cell.details.text = details[IndexPath.row][1]
            
            if(IndexPath.row % 2 == 0){
                cell.backgroundColor = UIColor.polar()  }
            else{
                cell.backgroundColor = UIColor.white  }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appointmenthistorycell") as! AppointmentHistoryCell
            
            cell.label.text = history[IndexPath.row][0]
            cell.details.text = history[IndexPath.row][1]
            
            if(IndexPath.row % 2 == 0){
                cell.backgroundColor = UIColor.polar()  }
            else{
                cell.backgroundColor = UIColor.white  }
            
            return cell
        }
        
        
        
        
    }

    
    
    
    

}
