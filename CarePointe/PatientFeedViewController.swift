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
    
    var restPatientUD = Array<Dictionary<String,String>>()
    /*
    var times = [String]()//PatientUpdateDate
    var dates = [String]()//"0:00 AM"
    var messageCreator = [String]()//CreatedBy
    var message = [String]()//PatientUpdateText
    var updatedFrom = [String]()//updated_from
    var updatedType = [String]()//update_type
 */
    var linkAddress = ""
    
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
        
        //Diable segment .isEnabled = false 
        patientFeedSegmentC.setEnabled(false, forSegmentAt: 1)
        
        //getTokenThenPatientUpdatesFromWebServer()
    }
    
    
    //This was added for REWIND segue called from PatientUpDateViewController function sendButtonTapped
    //Have to rewind segue back, get new data and reload table for changes to be seen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTokenThenPatientUpdatesFromWebServer()
        
//        let feedData = UserDefaults.standard.object(forKey: "feedData") as? [[String]] ?? [[String]]()
//            times = feedData.getColumn(column: 0)
//            dates = feedData.getColumn(column: 1)
//            messageCreator = feedData.getColumn(column: 2)
//            message = feedData.getColumn(column: 3)
//        //patientID 4
//            updatedFrom = feedData.getColumn(column: 5)
//            updatedType = feedData.getColumn(column: 6)
        
            //patientFeedTableView.reloadData()
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
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "PatientList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientListView") as UIViewController
        //vc.navigationController?.pushViewController(vc, animated: false)
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
    
    // helper functions
    
    // get update icon.   Images from http://fontawesome.io
    func getUpdateIcon(updatedFrom:String, updateType:String) -> UIImage
    {
        if (updateType != "") {
            switch updateType
            {
                case "Routine":
                    return UIImage(named:"fa-phone-square.png")!
                
                case "CICA", "Urgent":
                    return UIImage(named:"fa-exclamation-triangle.png")!
                
                case "IDT":
                    return UIImage(named:"fa-user-md.png")!
                
                default:
                    return UIImage(named:"fa-phone-square.png")!
            }
        } else {
            switch updatedFrom
            {
                case "referraldetails", "patientprofileidt":
                    return UIImage(named:"fa-user-md.png")!

                case "patientprofile", "careflows":
                    return UIImage(named:"fa-phone-square.png")!

                case "telemedvideo":
                    return UIImage(named:"fa-video-camera.png")!
                
                case "patientprofilescreening":
                    return UIImage(named:"fa-list-ul.png")!
                
                case "patientdocumentupload", "patientprofilerxuploadedlist":
                    return UIImage(named:"fa-file.png")!

                default:
                    return UIImage(named:"fa-phone-square.png")!
            }
        }
    }
    
    func getUpdateTitle(updatedFrom:String, updateType:String) -> String
    {
        if (updateType != "") {
            return updateType + ": " //"Routine" or "CICA" etc.
        } else {
            switch updatedFrom
            {
            case "referraldetails":
                return "Referral Details: "
                
            case "patientprofileidt":
                return "Patient Profile IDT: "
                
            case "patientprofile":
                return "Patient Profile: "
                
            case "careflows":
                return "Careflows: "
                
            case "telemedvideo":
                return "Tele-med Video: "
                
            case "patientprofilescreening":
                return "Patient Profile Screening: "
                
            case "patientdocumentupload":
                return "Patient Document Upload: "
                
            case "patientprofilerxuploadedlist":
                return "Patient Profile Rx Uploaded List: "
                
            default:
                return "Update: "
            }

        }
    }
    
    // web server functions
    
    func getTokenThenPatientUpdatesFromWebServer(){
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        // 0 get token again -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            //var dontShowToast = true //if viewDidLoad - don't 2x TOAST
            //if(showToast == "viewWillAppear") { dontShowToast = false}
            
            //GET UPDATES---------------------
            self.getPatientUpdatesFromWebServer(token: token)
            //-------------------------------
        }
    }

    func getPatientUpdatesFromWebServer(token: String){
        
        let demographics = UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//saved from PatientListVC
        let patientID = demographics[0][1]//"UniqueID"
        
        //print("patientID: \(patientID)")
        
        let patientUpdateFlag = DispatchGroup()
        patientUpdateFlag.enter()
        
        let pu = GETPatientUpdates()
        pu.getPatientUpdates(token: token, patientID: patientID, dispachInstance: patientUpdateFlag)
        
        patientUpdateFlag.notify(queue: DispatchQueue.main) {//pu sent back from cloud
            
            //print("here><><><><<><><><><")
            
            self.restPatientUD = UserDefaults.standard.object(forKey: "RESTPatientUpdates") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()

            //print("patientUpdates: \(self.restPatientUD)")
            
                let restPatientUDCount = self.restPatientUD.count
                self.view.makeToast("\(restPatientUDCount) Patient Updates pulled from cloud", duration: 1.1, position: .center)
            
            self.patientFeedTableView.reloadData()
            
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
        print("restPatientUD.count \(restPatientUD.count)")
        if(restPatientUD.isEmpty == false){
            return restPatientUD.count
        }
        else {
            return 0
        }
    }
    
    //return actual CELL to be displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientFeedCell") as! PatientFeedViewCell
        
        let updateData:Dictionary<String,String> = restPatientUD[indexPath.row]
        
        let update = getUpdateTitle(updatedFrom: updateData["updated_from"]!, updateType: updateData["update_type"]!)
        
        // 1 https://www.ioscreator.com/tutorials/attributed-strings-tutorial-ios8-swift
        /*let stringUpdate = update + updateData["PatientUpdateDate"]! as NSString//dates[indexPath.row] + " @ " + times[indexPath.row]  as NSString
        let stringCreatedBy = "Created by: " + updateData["CreatedBy"]! as NSString//messageCreator[indexPath.row] as NSString
        let attributedString1 = NSMutableAttributedString(string: stringUpdate as String)
        let attributedString2 = NSMutableAttributedString(string: stringCreatedBy as String)
        
        // 2
        let blackColor = [NSForegroundColorAttributeName: UIColor.black, NSBackgroundColorAttributeName: UIColor.white] as [String : Any]
        let blueColor = [NSForegroundColorAttributeName: UIColor.blue, NSBackgroundColorAttributeName: UIColor.white] as [String : Any]
        let otherColor = [NSForegroundColorAttributeName: UIColor.candyGreen(), NSBackgroundColorAttributeName: UIColor.white] as [String : Any]
        
        // 3
        attributedString1.addAttributes(blackColor, range: stringUpdate.range(of: "Update: "))
        attributedString1.addAttributes(blueColor, range: stringUpdate.range(of: updateData["CreatedBy"]!))
        //attributedString1.addAttributes(blackColor, range: stringUpdate.range(of: " @ "))
        //attributedString1.addAttributes(blueColor, range: stringUpdate.range(of: times[indexPath.row]))
        
        attributedString2.addAttributes(otherColor, range: stringCreatedBy.range(of: updateData["CreatedBy"]!))
        // 4
        //attributedLabel.attributedText = attributedString*/
        
        let shortDate = self.convertDateStringToDate(longDate: updateData["PatientUpdateDate"]!)
        
        cell.patientUpdateTitle.text = update + shortDate                   //.attributedText = attributedString1
        
        cell.createdBy.text = "Created by: " + updateData["CreatedBy"]!     //.attributedText = attributedString2
        

        
        let messageToCheckLink = updateData["PatientUpdateText"]!
        
        
        //check if message from patientUpdateTest contains a href link
        if messageToCheckLink.range(of:"<a href=") != nil{
            
            cell.patientUpdateMessage.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
            cell.patientUpdateMessage.addGestureRecognizer(tap)
            cell.patientUpdateMessage.text = returnLinkTitleGetLinkAddress(fullString: messageToCheckLink)//"View"
            cell.patientUpdateMessage.textColor = .blue
            
        } else {
            cell.patientUpdateMessage.text = updateData["PatientUpdateText"]!
            cell.patientUpdateMessage.textColor = .black
            
        }
        
          //message[indexPath.row]
        
        cell.feedImage.image = getUpdateIcon(updatedFrom: updateData["updated_from"]!, updateType: updateData["update_type"]!)
        
        return cell
    }
    
    func returnLinkTitleGetLinkAddress(fullString: String) -> String{
        
        if fullString.contains("=") {
        
            let stringArray = splitStringToArray(StringIn: fullString, deliminator: "=")
            
            
            var updateTitle = ""
            
            for element in stringArray {
                if element.hasSuffix("target") {
                    let endIndex = element.index(element.endIndex, offsetBy: -7)//6 len target
                    linkAddress = "https://carepointe.cloud/"+element.substring(to: endIndex)
                    print("\(linkAddress)")
                }
                if element.hasSuffix("href"){
                    let endIndex = element.index(element.endIndex, offsetBy: -7)//<a href
                    updateTitle = element.substring(to: endIndex)
                    print("\(updateTitle)")
                }
                
            }
            return updateTitle
            
        } else {
            return fullString
        }
        
    }
    
    // functions for clicking to web link
    func onClicLabel(sender:UITapGestureRecognizer) {
        if linkAddress != nil{
        openUrl(urlString: linkAddress)//"https://carepointe.cloud/episode_document/patient_1848/episode_1821/Monica_170513124300.pdf")
        }
    }
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
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
