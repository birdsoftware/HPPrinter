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
        ["1/1/2017","Home Health", "-"],
        ["-","-", "-"]
    ]
    
    
    
    //API Data
    var restServices = Array<Dictionary<String,String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegation
        servicesTable.delegate = self
        servicesTable.dataSource = self
        
        //Table ROW Height set to auto layout - row height grows with content
        servicesTable.rowHeight = UITableViewAutomaticDimension
        servicesTable.estimatedRowHeight = 75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //GET Referral by PatientID - See InfoContainer1VC.swift - func getBageandCaseFromLocationsAPI(token:String)
        
        restServices = UserDefaults.standard.object(forKey: "RESTPatientReferral") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
        
        if restServices.isEmpty == false {
            
            services.removeAll()
            
            for dict in restServices {
                
                let date = convertDateStringToDate(longDate: dict["StartDate"]!)
                
                services.append([date,dict["ServiceCategory"]!,dict["Status"]!])
            }
            
            //let admitDate = convertDateStringToDate(longDate: caseData["AdmittanceDate"]!)
            
            servicesTable.reloadData()
        } else {
            services.removeAll()
        }
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
