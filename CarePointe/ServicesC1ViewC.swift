//
//  ServicesC1ViewC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class ServicesC1ViewC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    //table view
    
    @IBOutlet weak var servicesTable: UITableView!
    
    var services = [
        ["Admin Admin","Home Health", "Completed"],
        ["Walter Simmons","Home Health", "Pending"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegation
        servicesTable.delegate = self
        servicesTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        servicesTable.rowHeight = UITableViewAutomaticDimension
        servicesTable.estimatedRowHeight = 75
    }
    
    //1 return # sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //2 return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(services.isEmpty == false){
            return services.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "servicescell", for: indexPath) as! servicesCell
        
        cell.label.text = services[indexPath.row][0]
        cell.details.text = services[indexPath.row][1]
        cell.details2.text = services[indexPath.row][2]
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.polar()  }
        else{
            cell.backgroundColor = UIColor.white  }
        
        return cell
    }
}
