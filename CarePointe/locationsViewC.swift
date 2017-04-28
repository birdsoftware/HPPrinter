//
//  locationsViewC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class locationsViewC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    //table view
    
    @IBOutlet weak var locationsTable: UITableView!
    
    var locations = [
        ["Banner Desert Medical Center","Home Visit","04/02/2017"],
        ["Life Care of Paradise valley","Home Visit","02/03/2017"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegation
        locationsTable.delegate = self
        locationsTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        locationsTable.rowHeight = UITableViewAutomaticDimension
        locationsTable.estimatedRowHeight = 75
    }
    

    //2 return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(locations.isEmpty == false){
            return locations.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationscell", for: indexPath) as! locationsCell
        
        cell.label.text = locations[indexPath.row][0]
        cell.details.text = locations[indexPath.row][1]
        cell.details2.text = locations[indexPath.row][2]
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.polar()  }
        else{
            cell.backgroundColor = UIColor.white  }
        
        return cell
    }
}
