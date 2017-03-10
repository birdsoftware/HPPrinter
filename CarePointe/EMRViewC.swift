//
//  EMRViewC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class EMRViewC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var emrTable: UITableView!
    
    let emrTitles = ["EMR Data 1","EMR Data 2","EMR Data 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //delegation
        emrTable.dataSource = self
        emrTable.delegate = self
        
    }

    //
    // #MARK: - Table View
    //
    
    //[2] RETURN number of ROWS in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(emrTitles.isEmpty == false){
            return emrTitles.count
        }
        else {
            return 0
        }
        
    }
    
    //[3] RETURN actual CELL to be displayed
    // SHOW SEGUE ->
    // " 1. click cell drag to second view. select the “show” segue in the “Selection Segue” section. "
    //http://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "emrupdatecell") as! EMRUpdateCell
        
        cell.EMRTitle.text = emrTitles[IndexPath.row]
        
        cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
        return cell
    }

    

}
