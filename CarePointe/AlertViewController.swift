//
//  AlertViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/27/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var alertTableView: UITableView!
    
    
    // class vars
        var searchActive : Bool = false
        var filteredAlerts:[String] = []
        var searchBar = UISearchBar()
    
    //class data
    var alertData = [
        ["Ruth Quinones","01/22/17 12:32AM","Careflows update 1 some more descrption text would go here"],
        ["Ruth Quinones","01/23/17 01:56PM","DISPOSITION Patient profile IDT Update some more descrption text would go here"],
        ["Barrie Thomson","01/23/17 03:22PM","Patient profile Update some more descrption text would go here"],
        ["Victor Owen","01/24/17 11:12AM","Telemed update some more descrption text would go here"],
        ["Bill Summers","01/25/17 10:52AM","Patient profile Screening update some more descrption text would go here"],
        ["Barrie Thomson","01/25/17 12:01PM","Referrals details update some more descrption text would go here"],
        ["Alice Njavro","01/26/17 07:02AM","patient profile update 2 some more descrption text would go here"],
        ["Elida Martinez","01/26/17 05:05PM","Patient medication some more descrption text would go here about medications and possible complications or interactions with dosage and medication type"],
        ["John Banks","01/26/17 07:25PM","patient Lunch Update some more descrption text would go here"],
        ["Patty Williams","01/26/17 09:43PM","DISPOSITION Patient profile IDT Update some more descrption text would go here"],
        ["Dian Simmons","01/27/17 12:32AM","musical IDT Update some more descrption text would go here"],
        ["Rrian Nird","01/27/17 01:56PM","Careflows update 1 some more descrption text would go here"],
        ["Josh Brown","01/27/17 03:22PM","DISPOSITION Patient profile IDT Update some more descrption text would go here"],
        ["Cindy Lopper","01/28/17 11:12AM","Patient profile Update some more descrption text would go here"],
        ["Dan Anderson","01/29/17 10:52AM","Telemed update some more descrption text would go here"],
        ["Paul Ryan","01/29/17 12:01PM","Patient profile Screening update some more descrption text would go here"],
        ["Ruth Quinones","01/30/17 07:02AM","Referrals details update some more descrption text would go here"],
        ["Betty Kim","01/30/17 05:05PM","patient profile update 2 some more descrption text would go here"],
        ["Sue Cohen","01/30/17 07:25PM","Patient medication some more descrption text would go here about medications and possible complications or interactions with dosage and medication type"],
        ["Jan Andrews","01/30/17 09:43PM","patient Lunch Update some more descrption text would go here"],
        ["Mike Devitt","01/31/17 10:23PM","DISPOSITION Patient profile IDT Update some more descrption text would go here"],
        ["Anita Cintash","02/01/17 09:11PM","musical IDT Update some more descrption text would go here"]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //delegation
        //alertSearchBar.delegate = self
        
        alertTableView.dataSource = self
        alertTableView.delegate = self
        
        //Table ROW Height set to auto layout - row height grows with content
        alertTableView.rowHeight = UITableViewAutomaticDimension
        alertTableView.estimatedRowHeight = 150
        
    }

    
    //
    // #MARK: - Search Functions
    //
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    var integerArray:[Int] = []
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        integerArray.removeAll()
        // filter loop
        filteredAlerts = alertData[2].filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            //filteredAlertImages = alertImageNames.filter({text -> Bool in range.location != NSNotFound})
            
            integerArray.append(range.location)
            return range.location != NSNotFound //NSNotFound is NSIntegerMax range.location if item not found returns 2^63 or 9223372036854775807
        })
        
        
        //works but ugly
//        var index = 1
//        filteredAlertImages.removeAll()
//        for i in integerArray {
//            if i != NSNotFound {
//                //TEST print("match \(i),\(index)") //testing
//                //add
//                filteredAlertImages.append(alertImageNames[index-1])
//                if(index < integerArray.count) {
//                    index += 1 }
//            }
//            else {
//                //remove
//                //TEST print("not match \(i),\(index)") //testing
//                if(index < integerArray.count) {
//                    index += 1 }
//            }
//        }
        //      for i in 1...integerArray.count {
        //          if integerArray[i] != NSNotFound {
        //             filteredAlertImages.append(alertImageNames[i])
        //         }
        //     }
        //TEST print("filteredAlertImages \(filteredAlertImages)") //testing
        
        if(filteredAlerts.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        alertTableView.reloadData()
    }

    
    //
    // #MARK: - Table View
    //
    
    //[2] RETURN number of ROWS in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filteredAlerts.count
        }
        
        return alertData.count
    }
    
    //[3] RETURN actual CELL to be displayed
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        

            let cell = tableView.dequeueReusableCell(withIdentifier: "alertcell") as! AlertTabelCell
            if(searchActive) {
//                cell.alertImage.image = UIImage(named: filteredAlertImages[IndexPath.row])
                cell.message.text = filteredAlerts[IndexPath.row]//12 spaces in front of alert: don't cover image
//                //change cell text color and cell background color
//                let textColor = returnAlertTextColor(alertImageName: filteredAlertImages[IndexPath.row])
//                cell.alertMessage.textColor = textColor
//                cell.backgroundColor = returnAlertBackGroundColor(alertImageName: filteredAlertImages[IndexPath.row])
            } else {
                cell.patientName.text = alertData[IndexPath.row][0]
                cell.date.text = alertData[IndexPath.row][1]
                cell.message.text = alertData[IndexPath.row][2]
                cell.date.textColor = UIColor(hex: 0x960C1E) //Pohutukawa
                cell.patientName.textColor = UIColor(hex: 0x960C1E) //Pohutukawa
                //cell.message.textColor = UIColor(hex: 0x960C1E) //Pohutukawa
                cell.backgroundColor = UIColor(hex: 0xF5CCCD) //Coral Candy
            }
            return cell
        }
    
    //DELETE row (the event) method
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //if (tableView == self.alertTableView)
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //remove from local array
            alertData.remove(at: (indexPath as NSIndexPath).row)
                //line of code above is the same as 2 lines below:
                //alertData[0].remove(at: (indexPath as NSIndexPath).row)
                //alertData[1].remove(at: (indexPath as NSIndexPath).row)
            alertTableView.reloadData()
            //update alert badge number
            //rightBarButtonAlert.addBadge(number: alertData.count)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
