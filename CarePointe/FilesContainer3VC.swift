//
//  FilesContainer3VC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/8/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class FilesContainer3VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filesTable: UITableView!
    
    
    
    var files = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegation
        filesTable.delegate = self
        filesTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        filesTable.rowHeight = UITableViewAutomaticDimension
        filesTable.estimatedRowHeight = 150
        
        files = [["file 1","PDF"],
                  ["file 2","DOC"],
                  ["BMI file 3","PIC"],
                  ["BMI file 4","PDF"],
                  ["file 5 Temperature","PDF"],
                  ["BP file 6","Left"],
                  ["file 6 Sys/Dia","PDF"],
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
        
        return files.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "files") as! filesCell
        
        cell.label.text = files[IndexPath.row][0]
        cell.details.text = files[IndexPath.row][1]
        
        if(IndexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.polar()  }
        else{
            cell.backgroundColor = UIColor.white  }
        
        cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
        return cell
    }
    

}
