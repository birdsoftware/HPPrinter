//
//  PatientFeedViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var patientTitleLabel: UILabel!
    @IBOutlet weak var leaveAnUpdate: UIButton!
    
    //table view
    @IBOutlet weak var patientFeedTableView: UITableView!
    
    //segment control
    @IBOutlet weak var patientFeedSegmentC: UISegmentedControl!
    
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var containerView2: UIView!
    
    
    var times = [String]()
    var dates = [String]()
    var messageCreator = [String]()
    var message = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show patient Name in title
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        patientTitleLabel.text = patientName! + "'s Updates"
        
        //table view delegate
        patientFeedTableView.delegate = self
        patientFeedTableView.dataSource = self
        
        //Table ROW Height set to auto layout
        patientFeedTableView.rowHeight = UITableViewAutomaticDimension
        patientFeedTableView.estimatedRowHeight = 150//was 88 and is 88 in storyboard
        
        //round button corner
        leaveAnUpdate.layer.cornerRadius = leaveAnUpdate.frame.size.width / 2
        leaveAnUpdate.clipsToBounds = true
        //scale button down
        leaveAnUpdate.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        
        // Hide container views
        containerView1.isHidden = true
        containerView2.isHidden = true
        
        // Setup sement control font and font size
        let attr = NSDictionary(object: UIFont(name: "Futura", size: 16.0)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
    }
    
    
    //This was added for REWIND segue called from PatientUpDateViewController function sendButtonTapped
    //Have to rewind segue back, get new data and reload table for changes to be seen
    override func viewWillAppear(_ animated: Bool) {
        
        let feedData = UserDefaults.standard.object(forKey: "feedData") as? [[String]] ?? [[String]]()
            times = feedData.getColumn(column: 0)
            dates = feedData.getColumn(column: 1)
            messageCreator = feedData.getColumn(column: 2)
            message = feedData.getColumn(column: 3)
            
            patientFeedTableView.reloadData()
    }
    
    
    // Buttons
    
    @IBAction func feedsSegmentControllerTapped(_ sender: Any) {
        
        switch patientFeedSegmentC.selectedSegmentIndex
        {
        case 0:
            containerView1.isHidden = true
            containerView2.isHidden = true
        case 1:
            containerView1.isHidden = false
            containerView2.isHidden = true
        case 2:
            containerView1.isHidden = true
            containerView2.isHidden = false
        default:
            break;
        }

    }
    
    
    //
    // #MARK: - UNWIND SEGUE
    //
    
    //https://www.andrewcbancroft.com/2015/12/18/working-with-unwind-segues-programmatically-in-swift/
    @IBAction func unwindToPatientFeed(segue: UIStoryboardSegue) {}
    
    //
    // #MARK: - Table View
    //
    
    //return number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(message.isEmpty == false){
            return message.count
        }
        else {
            return 0
        }
    }
    
    //return actual CELL to be displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientFeedCell") as! PatientFeedViewCell
        
        //        let updateDate = "Update: "// + dates[indexPath.row]
        //        let updateTime = " @ " + times[indexPath.row]
        //        let updateString = updateDate + updateTime + " " + messageCreator[indexPath.row]
        //
        //
        //        let yourAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        //        let yourOtherAttributes = [NSForegroundColorAttributeName: UIColor.blue, NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        //
        //        let partOne = NSMutableAttributedString(string: "Update: ", attributes: yourAttributes)
        //        let partTwo = NSMutableAttributedString(string: "for the combination of Attributed String!", attributes: yourOtherAttributes)
        //
        //        let combination = NSMutableAttributedString()
        //
        //        combination.append(partOne)
        //        combination.append(partTwo)
        
        // 1 https://www.ioscreator.com/tutorials/attributed-strings-tutorial-ios8-swift
        let stringUpdate = "Update: " + dates[indexPath.row] + " @ " + times[indexPath.row]  as NSString
        let stringCreatedBy = "Created by: " + messageCreator[indexPath.row] as NSString
        let attributedString1 = NSMutableAttributedString(string: stringUpdate as String)
        let attributedString2 = NSMutableAttributedString(string: stringCreatedBy as String)
        
        // 2
        let blackColor = [NSForegroundColorAttributeName: UIColor.black, NSBackgroundColorAttributeName: UIColor.white] as [String : Any]
        let blueColor = [NSForegroundColorAttributeName: UIColor.blue, NSBackgroundColorAttributeName: UIColor.white] as [String : Any]
        let otherColor = [NSForegroundColorAttributeName: UIColor.candyGreen(), NSBackgroundColorAttributeName: UIColor.white] as [String : Any]
        
        // 3
        attributedString1.addAttributes(blackColor, range: stringUpdate.range(of: "Update: "))
        attributedString1.addAttributes(blueColor, range: stringUpdate.range(of: dates[indexPath.row]))
        attributedString1.addAttributes(blackColor, range: stringUpdate.range(of: " @ "))
        attributedString1.addAttributes(blueColor, range: stringUpdate.range(of: times[indexPath.row]))
        
        attributedString2.addAttributes(otherColor, range: stringCreatedBy.range(of: messageCreator[indexPath.row]))
        // 4
        //attributedLabel.attributedText = attributedString
        
        cell.patientUpdateTitle.attributedText = attributedString1//combination.string
        cell.createdBy.attributedText = attributedString2
        cell.patientUpdateMessage.text = message[indexPath.row]
        
        return cell
    }
//DONT REMOVE 
    //times dates messageCreator message
    //DELETE row (the event) method
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        //if (tableView == self.alertTableView)
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            //remove from local array
//            times.remove(at: (indexPath as NSIndexPath).row)
//            dates.remove(at: (indexPath as NSIndexPath).row)
//            messageCreator.remove(at: (indexPath as NSIndexPath).row)
//            message.remove(at: (indexPath as NSIndexPath).row)
//            //line of code above is the same as 2 lines below:
//            //alertData[0].remove(at: (indexPath as NSIndexPath).row)
//            //alertData[1].remove(at: (indexPath as NSIndexPath).row)
//            patientFeedTableView.reloadData()
//            //update alert badge number
//            //rightBarButtonAlert.addBadge(number: alertData.count)
//        }
//    }
    
}
