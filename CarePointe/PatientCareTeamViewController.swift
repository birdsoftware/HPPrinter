//
//  PatientCareTeamViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientCareTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //TOP BAR OUTLETS
//    @IBOutlet weak var careProviderImage: UIImageView!
//    @IBOutlet weak var backButton: UIButton!
//    @IBOutlet weak var careTeamTitle: UILabel!
    
    //TABLE VIEW OUTLETS
    @IBOutlet weak var patientCareTeamTable: UITableView!
    
    //Test data
    
    var careTeamPhoneNumbers = ["tel://8556235691","tel://8556235691","tel://8556235691","tel://8556235691"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //round careTeam button
       // careProviderImage.layer.cornerRadius = 0.5 * careProviderImage.bounds.size.width
       // careProviderImage.clipsToBounds = true
       // updateToSavedImage(Userimage: careProviderImage)
        
        //scale back '<' button down
       // backButton.imageEdgeInsets = UIEdgeInsetsMake(8,8,8,8)
        
        //show patient Name in title
      //  let patientName = UserDefaults.standard.string(forKey: "patientName")
      //  careTeamTitle.text = patientName! + "'s Care Team"
        
        // delegate 
        patientCareTeamTable.delegate = self //table view
        patientCareTeamTable.dataSource = self
    }
    
    //
    // MARK: - Button Actions
    //
    
    @IBAction func unwindToPatientDashboardButtonTapped(_ sender: Any) {
        //1. palce "@IBAction func unwindToPatientDashboard(segue: UIStoryboardSegue) {}" in view controller you want to unwind too
        //2. In storyboard connect this view () -> to [exit]: creates "Unwind segue" in this view not view unwind too
        //   In storyboard click "Unwind segue" set unwind segue identifier: "unwindToPatientDB"
        //                                                           Action: "unwindToPatientDashboardWithSegue:"
        //3. Trigger unwind segue programmatically (below)
        self.performSegue(withIdentifier: "unwindToPatientDB", sender: self)
    }
    
    
    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        let cell: PatientCareTeamCell = tableView.dequeueReusableCell(withIdentifier: "patientCareTeamCell") as! PatientCareTeamCell
        
        //set tag of the button since we are using it
        cell.patientCTCallButton.tag = IndexPath.row
        
        //add target to the buttom
        cell.patientCTCallButton.addTarget(self, action: #selector(connected), for: .touchUpInside)
        
        cell.patientCareTeamName.text = "Smith, James"
        return cell
    }
    
    func connected(sender: UIButton) {
        //get the tag in this connected function
            //let buttonTag = sender.tag
        //call care team member
            //callCareTeamMember(member: buttonTag)
        open(scheme: "tel://8556235691")
    }
    
    func callCareTeamMember(member: Int) {
        open(scheme: "tel://8556235691")//careTeamPhoneNumbers[member])
    }
    
    //Supports CALL
    func open(scheme: String) {
        //http://useyourloaf.com/blog/openurl-deprecated-in-ios10/
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
}
