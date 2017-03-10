//
//  InfoContainer1VC.swift
//  CarePointe
//
//  Created by Brian Bird on 3/8/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class InfoContainer1VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var careTeamButton: UIButton!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientImage: UIImageView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var badgeLabel2: UILabel!
    
    //table
    @IBOutlet weak var demographicsTable: UITableView!
    
    var demographics = [[String]]()
    var patientName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //careTeam button round button
        careTeamButton.layer.cornerRadius = 0.5 * careTeamButton.bounds.size.width
        careTeamButton.clipsToBounds = true
        patientImage.layer.borderWidth = 4
        patientImage.layer.borderColor = UIColor.celestialBlue().cgColor
        patientImage.layer.cornerRadius = 0.5 * patientImage.bounds.size.width
        patientImage.clipsToBounds = true
        
        //delegation
        demographicsTable.delegate = self
        demographicsTable.dataSource = self
        
        
        // BADGES
        //INPUT 1. Int: emojiNumber, UIColor: .candyGreen(), .Iron(), String: Alert, location
        
        let iconsSize = CGRect(x: 5, y: -2, width: 18, height: 18)
        let emojisCollection = [UIImage(named: "SurveyWhite"), UIImage(named: "FeedWhite"), UIImage(named: "handicap.png")]
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let attachment = NSTextAttachment()
        attachment.image = emojisCollection[0]
        attachment.bounds = iconsSize
        attributedString.append(NSAttributedString(attachment: attachment))
        attributedString.append(NSAttributedString(string: " INP-Residence "))
        
        badgeLabel.attributedText = attributedString
        
        badgeLabel.layer.cornerRadius = 5
        badgeLabel.backgroundColor = UIColor.candyGreen()
        badgeLabel.clipsToBounds = true
        
        // badgeLabel2 ---
        let careGiver = NSTextAttachment()
        careGiver.image = emojisCollection[2]
        careGiver.bounds = iconsSize
        
        let attributedString2 = NSMutableAttributedString(string: "")
        attributedString2.append(NSAttributedString(attachment: careGiver))
        attributedString2.append(NSAttributedString(string: " Caregiver "))
        
        badgeLabel2.attributedText = attributedString2
        badgeLabel2.layer.cornerRadius = 5
        badgeLabel2.backgroundColor = UIColor.Iron()
        badgeLabel2.clipsToBounds = true
        
        
        // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        patientName = UserDefaults.standard.string(forKey: "patientName")!
        patientNameLabel.text = patientName + "'s Information"
        // show patient photo
        let patientPic = UserDefaults.standard.string(forKey: "patientPic")!
        if(patientPic.isEmpty == false){
            patientImage.image = UIImage(named: patientPic)
            
        }
        
        //Table ROW Height set to auto layout - row height grows with content
        demographicsTable.rowHeight = UITableViewAutomaticDimension
        demographicsTable.estimatedRowHeight = 150
        
        demographics = [["UniqueID","P000001"],
                            ["Assigned","Gabe towers"],
                            ["Gender","Female"],
                            ["Ethnicity","Hispanic/Latino"],
                            ["SSN#","343-14-3434"],
                            ["DOB","07/10/1947"],
                            ["Primary Language","English"],
                            ["Email","demo@gmail.com"],
                            ["Intake Notes","Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut turpis odio, porta a erat ac, porttitor lacinia elit. Fusce molestie scelerisque urna, non ullamcorper erat condimentum at. Vivamus id nisl dui. Nam egestas justo ut metus dapibus, at placerat mauris ullamcorper. Donec aliquam metus ligula. Maecenas dui lectus, tempor eu faucibus nec, tincidunt non sapien. Pellentesque pellentesque, eros eget feugiat elementum, ante orci rhoncus felis, congue pulvinar sem lorem id elit. Donec placerat vitae neque sed volutpat."],
                            ["Home Address","City Street, Suite 100"],
                            ["City","NY"],
                            ["Zip","10011"],
                            ["Phone","(816) 679-4482"],
                            ["Cell","(702) 688-9673"],
                            ["Additional Contact","Marie Smith"],
                            ["Contact Relationship","Sister"],
                            ["Contact Phone","(321) 134-5244"],
                            ["Contact Notes","Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut turpis odio, porta a erat ac, porttitor lacinia elit. Fusce molestie scelerisque urna, non ullamcorper erat condimentum at. Vivamus id nisl dui. Nam egestas justo ut metus dapibus, at placerat mauris ullamcorper. Donec aliquam metus ligula. Maecenas dui lectus, tempor eu faucibus nec, tincidunt non sapien. Pellentesque pellentesque."]
        ]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("didReceiveMemoryWarning-InfoContainer1VC")
    }
    

    //
    // #MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return demographics.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "demographics") as! InfoDemographicsCell
        
        cell.Label.text = demographics[IndexPath.row][0]
        cell.details.text = demographics[IndexPath.row][1]
        
        if(IndexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.polar()  }
        else{
            cell.backgroundColor = UIColor.white  }
        
        return cell
    }
    

}
