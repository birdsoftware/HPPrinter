//
//  AlertViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/27/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit


class AlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // table
    @IBOutlet weak var alertTableView: UITableView!
    
    //search bar
    @IBOutlet weak var alertSearchBar: UISearchBar!
    
    
    // class vars
        var searchActive : Bool = false
        var filteredAlerts:[String] = []
        var filteredAlertNames:[String] = []
        var filteredDateTimes:[String] = []
        var searchBar = UISearchBar()
    
    //class data
    var alertData = [[String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //delegation
        alertSearchBar.delegate = self
        
        alertTableView.dataSource = self
        alertTableView.delegate = self
        
        //Table ROW Height set to auto layout - row height grows with content
        alertTableView.rowHeight = UITableViewAutomaticDimension
        alertTableView.estimatedRowHeight = 150
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        alertData = UserDefaults.standard.object(forKey: "alertData") as? [[String]] ?? [[String]]()
        //Note - The nil coalescing operator (??) allows you to return the saved array or an empty array without
        // crashing. It means that if the object returns nil, then the value following the ?? operator will be 
        // used instead.
        
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
        searchActive = false
        alertSearchBar.text = ""
        alertSearchBar.endEditing(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        //alertSearchBar.endEditing(true)
    }
    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        // Stop doing the search stuff
//        // and clear the text in the search bar
//        searchBar.text = ""
//        // Hide the cancel button
//        searchBar.showsCancelButton = false
//        // You could also change the position, frame etc of the searchBar
//        searchActive = false;
//        // Remove focus from the search bar.
//        searchBar.endEditing(true)
//    }
    
    var integerArray:[Int] = []
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        integerArray.removeAll()
        let alertMessageColumn = alertData.getColumn(column: 2)
        // filter loop
        filteredAlerts = alertMessageColumn.filter({ (text) -> Bool in //alertData[2]
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            //filteredAlertImages = alertImageNames.filter({text -> Bool in range.location != NSNotFound})
            
            integerArray.append(range.location)
            return range.location != NSNotFound //NSNotFound is NSIntegerMax range.location if item not found returns 2^63 or 9223372036854775807
        })
        
        
        //works but ugly
        var index = 1
        filteredAlertNames.removeAll()
        filteredDateTimes.removeAll()
        for i in integerArray {
            if i != NSNotFound {
                //TEST print("match \(i),\(index)") //testing
                //add
                filteredAlertNames.append(alertData[index-1][0])
                filteredDateTimes.append(alertData[index-1][1])
                if(index < integerArray.count) {
                    index += 1 }
            }
            else {
                //remove
                //TEST print("not match \(i),\(index)") //testing
                if(index < integerArray.count) {
                    index += 1 }
            }
        }
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
                cell.patientName.text = filteredAlertNames[IndexPath.row]
                cell.date.text = filteredDateTimes[IndexPath.row]
                cell.message.text = filteredAlerts[IndexPath.row]
                cell.date.textColor = UIColor(hex: 0x960C1E) //Pohutukawa
                cell.patientName.textColor = UIColor(hex: 0x960C1E) //Pohutukawa
                //cell.message.textColor = UIColor(hex: 0x960C1E) //Pohutukawa
                cell.backgroundColor = UIColor(hex: 0xF5CCCD) //Coral Candy
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
            UserDefaults.standard.set(alertData.count, forKey: "alertCount")
            UserDefaults.standard.set(alertData, forKey: "alertData")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateAlert"), object: nil)
            alertTableView.reloadData()
            
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
