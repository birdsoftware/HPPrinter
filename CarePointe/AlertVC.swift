//
//  AlertViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/27/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit


class AlertVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // table
    //@IBOutlet weak var alertTableView: UITableView!
    @IBOutlet weak var alertTableView: UITableView!
    
    //search bar
    //@IBOutlet weak var alertSearchBar: UISearchBar!
    @IBOutlet weak var alertSearchBar: UISearchBar!
    
    
    // class vars
        var searchActive : Bool = false
        var alertData:Array<Dictionary<String,String>> = []
        var SearchData:Array<Dictionary<String,String>> = []
    
//        var filteredAlerts:[String] = []
//        var filteredAlertNames:[String] = []
//        var filteredDateTimes:[String] = []
//        var searchBar = UISearchBar()
//    
//    //class data
//    var alertData = [[String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //delegation
        //alertSearchBar.delegate = self
        alertSearchBar.delegate = self
        
        alertTableView.dataSource = self
        alertTableView.delegate = self
        
        //Table ROW Height set to auto layout - row height grows with content
        alertTableView.rowHeight = UITableViewAutomaticDimension
        alertTableView.estimatedRowHeight = 150
        
        // change the color of cursol and cancel button.
        alertSearchBar.tintColor = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //alertData = UserDefaults.standard.object(forKey: "RESTGlobalAlerts") as? [[String]] ?? [[String]]()
        //Note - The nil coalescing operator (??) allows you to return the saved array or an empty array without
        // crashing. It means that if the object returns nil, then the value following the ?? operator will be 
        // used instead.

        if isKeyPresentInUserDefaults(key: "RESTGlobalAlerts"){
            alertData = UserDefaults.standard.value(forKey: "RESTGlobalAlerts") as! Array<Dictionary<String, String>>
        }
        SearchData = alertData
        alertTableView.reloadData()
    }


    //
    // #MARK: - Buttons
    //
    @IBAction func backButtonTapped(_ sender: Any) {
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController
        //vc.navigationController?.pushViewController(vc, animated: false)
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
    
    //
    // #MARK: - Search Functions
    //
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("PLsearch: \(searchText)")
        let predicate=NSPredicate(format: "SELF.alert_access_roles CONTAINS[cd] %@", searchText) // returns .patientName from patientName["patientName"]
        let arr=(alertData as NSArray).filtered(using: predicate)
        
        if arr.count > 0
        {
            SearchData=arr as! Array<Dictionary<String,String>>
        } else {
            SearchData=alertData
        }
        alertTableView.reloadData()
    }
    
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
    
////    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
////        // Stop doing the search stuff
////        // and clear the text in the search bar
////        searchBar.text = ""
////        // Hide the cancel button
////        searchBar.showsCancelButton = false
////        // You could also change the position, frame etc of the searchBar
////        searchActive = false;
////        // Remove focus from the search bar.
////        searchBar.endEditing(true)
////    }
//    
//    var integerArray:[Int] = []
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        integerArray.removeAll()
//        let alertMessageColumn = alertData.getColumn(column: 2)
//        // filter loop
//        filteredAlerts = alertMessageColumn.filter({ (text) -> Bool in //alertData[2]
//            let tmp: NSString = text as NSString
//            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//            
//            //filteredAlertImages = alertImageNames.filter({text -> Bool in range.location != NSNotFound})
//            
//            integerArray.append(range.location)
//            return range.location != NSNotFound //NSNotFound is NSIntegerMax range.location if item not found returns 2^63 or 9223372036854775807
//        })
//        
//        
//        //works but ugly
//        var index = 1
//        filteredAlertNames.removeAll()
//        filteredDateTimes.removeAll()
//        for i in integerArray {
//            if i != NSNotFound {
//                //TEST print("match \(i),\(index)") //testing
//                //add
//                filteredAlertNames.append(alertData[index-1][0])
//                filteredDateTimes.append(alertData[index-1][1])
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
//        //      for i in 1...integerArray.count {
//        //          if integerArray[i] != NSNotFound {
//        //             filteredAlertImages.append(alertImageNames[i])
//        //         }
//        //     }
//        //TEST print("filteredAlertImages \(filteredAlertImages)") //testing
//        
//        if(filteredAlerts.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        alertTableView.reloadData()
//    }

    
    //
    // #MARK: - Table View
    //
    
    //[2] RETURN number of ROWS in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(SearchData.isEmpty == false){
            return SearchData.count
        }
        else {
            return 0
        }

    }
    
    //[3] RETURN actual CELL to be displayed
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
    

        let cell = tableView.dequeueReusableCell(withIdentifier: "alertcell") as! AlertTabelCell
        
        var Data:Dictionary<String,String> = SearchData[IndexPath.row]
        //        "alertid", "alert_name":, "alert_category", "alert_position", "alert_access", "alert_message":, "created_date", "alert_access_roles")
        
                cell.alertName.text = Data["alert_name"]
                cell.patientName.text = Data["alert_access_roles"]
                cell.date.text = Data["created_date"]
                cell.message.text = Data["alert_message"]
                cell.date.textColor = UIColor(hex: 0x960C1E) //Pohutukawa
                cell.patientName.textColor = UIColor(hex: 0x960C1E) //Pohutukawa
                //cell.message.textColor = UIColor(hex: 0x960C1E) //Pohutukawa
                cell.backgroundColor = UIColor(hex: 0xF5CCCD) //Coral Candy
//                let textColor = returnAlertTextColor(alertImageName: filteredAlertImages[IndexPath.row])
//                cell.alertMessage.textColor = textColor
//                cell.backgroundColor = returnAlertBackGroundColor(alertImageName: filteredAlertImages[IndexPath.row])
        
            return cell
        }
    
    //DELETE row (the event) method
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //if (tableView == self.alertTableView)
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //remove from local array
            //alertData.remove(at: (indexPath as NSIndexPath).row)
            SearchData.remove(at: (indexPath as NSIndexPath).row)

//            UserDefaults.standard.set(alertData, forKey: "RESTGlobalAlerts") TODO: save and search? maybe no search?
//            UserDefaults.standard.synchronize()
            
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateAlert"), object: nil)
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
