//
//  InboxViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/21/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newEmailButton: RoundedButton!
    
    @IBOutlet weak var inboxTable: UITableView!
    
    
    var fromName = [["Dr Quinones", "Dr B. Thomson", "Victor Owen", "Bill Summers", "Alice Njavro", "Michael Levi", "Elida Martinez", "John Banks","Rrian Nird"],
                    [ "Cindy Lopper","Marx Ehrlich", "Alicia Watanabe", "Josh Brown"],
                    [ "Desire Aller", "Paulita Wix", "Jenny Binkley", "Lawanda Arno", "Jackqueline Naumann", "Regine Kohnke","Brad Birdsong", "Dallas Remy", "Noel Devitt","Mike Brown","Sev Donada"]]
    
    var inTime = [["12:32 AM","01:56 PM","03:22 PM","11:12 AM","10:52 AM","12:01 PM","07:02 AM","05:05 PM","07:25 PM"],
                 ["12:32 AM","01:56 PM","03:22 PM","11:12 AM"],
                 ["12:32 AM","01:56 PM","03:22 PM","11:12 AM","10:52 AM","12:01 PM","07:02 AM","05:05 PM","07:25 PM","09:43 PM","10:52 AM"]]
    
    var inDate = [["2/15/17","2/16/17","2/15/17","3/14/17","3/14/17","2/14/16","3/15/16","2/13/17","2/14/17"],
                 ["2/14/17","2/14/17","2/14/17","2/14/17"],
                 ["2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17","2/14/17"]]
    
    var inMessage = [["Careflows update 1", "DISPOSITION Patient profile IDT Update",
                               "order blood pressure plate", "Dr D. Webb Telemed update",
                               "Patient profile Screening update", "Referrals details update",
                               "syn patient card data", "Patient medication",
                               "new nutrition levels"],
                              ["new nutrition levels", "interface IDT Update",
                               "Monitor infusion plasma", "DISPOSITION Patient profile IDT Update"],
                              ["Patient profile Update", "Telemed update",
                               "Patient profile Screening update", "Referrals details update",
                               "monitor profile update 2", "Patient medication calculation",
                               "patient Lunch Update", "hearing aid configuration","Dr D. Webb Telemed update",
                               "Patient profile Screening update", "Referrals details update"]]
    var inFromTitle = [["Physician Phy2","Physician Phy1","Case Manager","Care Provider 1","Physician Phy2","Physician Phy1","Case Manager","Care Provider 1","Case Manager"],
                       ["Physician Phy2","Physician Phy1","Case Manager","Care Provider 1"],
                       ["Physician Phy2","Physician Phy1","Case Manager","Care Provider 1","Physician Phy2","Physician Phy1","Case Manager","Care Provider 1","Physician Phy2","Physician Phy1","Case Manager"]]
    var inSubject = [["Patient update 1", "Patient IDT Update",
                      "order blood pressure plate", "Dr D. Webb Telemed update",
                      "Patient profile Screening update", "Referrals details update",
                      "syn patient card data", "Patient medication",
                      "new nutrition levels"],
                     ["Patient update 1", "interface IDT Update",
                      "Monitor infusion plasma", "DISPOSITION Patient profile IDT Update"],
                     ["Patient update 1", "Patient update 2",
                      "Patient profile Screening update", "Referrals details update",
                      "monitor profile update 2", "Patient medication calculation",
                      "patient Lunch Update", "hearing aid configuration","Dr D. Webb Telemed update",
                      "Patient profile Screening update", "Referrals details update"]]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup UI/UX
            //round careTeam button
                newEmailButton.layer.cornerRadius = 0.5 * newEmailButton.bounds.size.width
                newEmailButton.clipsToBounds = true
            //scale button down
                newEmailButton.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        
        //delegates
            inboxTable.delegate = self
            inboxTable.dataSource = self
        
    }

    
    
    //
    // MARK: - Button Actions
    //
    
    
    @IBAction func goBackButtonTapped(_ sender: Any) {
        //1. palce "@IBAction func unwindToPatientDashboard(segue: UIStoryboardSegue) {}" in view controller you want to unwind too
        //2. In storyboard connect this view () -> to [exit]: creates "Unwind segue" in this view not view unwind too
        //   In storyboard click "Unwind segue" set unwind segue identifier: "unwindToMainDB"
        //                                                           Action: "unwindToMainDashboard:"
        //3. Trigger unwind segue programmatically (below)
        self.performSegue(withIdentifier: "unwindToMainDB", sender: self)
    }


    //
    // MARK: - Table View
    //
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fromName[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell") as! InboxCell
        
        cell.inboxStatusImage.image = UIImage(named: "orange.circle.png")
        cell.inboxFromTitle.text = inFromTitle[0][IndexPath.row]
        cell.inboxFromName.text = fromName[0][IndexPath.row]
        cell.inboxSubject.text = inSubject[0][IndexPath.row]
        cell.inboxMessageShort.text = inMessage[0][IndexPath.row]
        cell.inboxDate.text = inDate[0][IndexPath.row]
        cell.inboxTime.text = inTime[0][IndexPath.row]
        
        return cell
    
    }
    
    //DELETE row (the event) method
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //if (tableView == self.alertTableView)
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //remove from local array
            inFromTitle[0].remove(at: (indexPath as NSIndexPath).row)
            fromName[0].remove(at: (indexPath as NSIndexPath).row)
            inSubject[0].remove(at: (indexPath as NSIndexPath).row)
            inMessage[0].remove(at: (indexPath as NSIndexPath).row)
            inDate[0].remove(at: (indexPath as NSIndexPath).row)
            inTime[0].remove(at: (indexPath as NSIndexPath).row)
            
            //let inboxCount = fromName[0].count
            //let inboxCount = UserDefaults.standard.integer(forKey: "inboxCount")
            //UserDefaults.standard.set(inboxCount, forKey: "inboxCount")
            //UserDefaults.standard.synchronize()
            
            
            inboxTable.reloadData()
        }
    }
    
}




