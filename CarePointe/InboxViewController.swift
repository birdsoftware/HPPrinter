//
//  InboxViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/21/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var newEmailButton: UIButton!
    
    //search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var inBoxSent: UISegmentedControl!
    // table
    @IBOutlet weak var inboxTable: UITableView!
    
    // class vars
    var searchActive : Bool = false
    var inBoxData:Array<Dictionary<String,String>> = []
    var sentBoxData:Array<Dictionary<String,String>> = []
    var SearchData:Array<Dictionary<String,String>> = []
    var selectedSegmentIndexValue:Int = 0
    
    //API data
    var restInbox:Array<Dictionary<String,String>> = []
    var recipients:Array<Dictionary<String,String>> = []
    var recipientsNameTitle:Array<Dictionary<String,String>> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTokenThenInboxMessagesFromWebServer()
        
        //get messages
        if isKeyPresentInUserDefaults(key: "RESTUserInbox"){//""userData"){
            restInbox = UserDefaults.standard.object(forKey: "RESTUserInbox") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
        }
        if restInbox.isEmpty == true {
        restInbox = [["SendBy":"", "Subject":"", "message":"",
                     "CreatedDate":"", "CreatedTime":"", "IsRead":"", "ID":""]]
        }
        //get recipients
        if isKeyPresentInUserDefaults(key: "RESTInboxUsers"){
            recipients = UserDefaults.standard.object(forKey: "RESTInboxUsers") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
        }
        
        //UserDefaults.standard.set("Inbox", forKey: "boxSegment")
        //UserDefaults.standard.synchronize()
        
        let count = restInbox.count
        inBoxSent.setTitle("Inbox (\(count))", forSegmentAt: 0)
        
        let sentBoxData = UserDefaults.standard.value(forKey: "sentData") as! Array<Dictionary<String, String>>
        let count2 = sentBoxData.count
        inBoxSent.setTitle("Sent (\(count2))", forSegmentAt: 1)
        
//        if isKeyPresentInUserDefaults(key: "inBoxData"){
//            inBoxData = UserDefaults.standard.value(forKey: "inBoxData") as! Array<Dictionary<String, String>>
//            inBoxSent.setTitle("Inbox (\(inBoxData.count))", forSegmentAt: 0)
//        } else {
//            inBoxSent.setTitle("Inbox (\(0))", forSegmentAt: 0)
//        }
//        if isKeyPresentInUserDefaults(key: "sentData"){
//            sentBoxData = UserDefaults.standard.value(forKey: "sentData") as! Array<Dictionary<String, String>>
//            inBoxSent.setTitle("Sent (\(sentBoxData.count))", forSegmentAt: 1)
//        } else {
//            inBoxSent.setTitle("Sent (\(0))", forSegmentAt: 1)
//        }
//        
        SearchData = inBoxData//need this to start off tableView with all data and not blank table

        // Setup UI/UX
            //round careTeam button
                //newEmailButton.layer.cornerRadius = 0.5 * newEmailButton.bounds.size.width
                //newEmailButton.clipsToBounds = true
                //newEmailButton.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        
        // Setup sement control font and font size
                let attr = NSDictionary(object: UIFont(name: "Futura", size: 16.0)!, forKey: NSFontAttributeName as NSCopying)
                UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        //delegates
            inboxTable.delegate = self
            inboxTable.dataSource = self
            searchBar.delegate = self
        
        inboxTable.rowHeight = UITableViewAutomaticDimension
        inboxTable.estimatedRowHeight = 90
    }

    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        getTokenThenInboxMessagesFromWebServer()
//        
//    }
    
    // UI Segment Control
    
    @IBAction func inBoxSentSegmentSelected(_ sender: Any) {
        switch inBoxSent.selectedSegmentIndex
        {
        case 0:
            //UserDefaults.standard.set("Inbox", forKey: "boxSegment")
            //UserDefaults.standard.synchronize()
            
            searchBar.placeholder = "Search Inbox"
            selectedSegmentIndexValue = 0
            if isKeyPresentInUserDefaults(key: "inBoxData") {
                inBoxData = UserDefaults.standard.value(forKey: "inBoxData") as! Array<Dictionary<String, String>>
            }
            SearchData = inBoxData
            inboxTable.reloadData()
        case 1:
            //UserDefaults.standard.set("Sent", forKey: "boxSegment")
            //UserDefaults.standard.synchronize()
            searchBar.placeholder = "Search Sent"
            selectedSegmentIndexValue = 1
            if isKeyPresentInUserDefaults(key: "sentData"){
                sentBoxData = UserDefaults.standard.value(forKey: "sentData") as! Array<Dictionary<String, String>>
            }
            SearchData = sentBoxData
            inboxTable.reloadData()
        default:
            break;
        }
    }
    
    
    
    //
    // #MARK: - helper functions
    //
    
    func returnFirstRecipientNamePlusCountOfRemainingRecipients(RecipientLine: String) -> String{
        
        var fromString = RecipientLine //Return Recipient if there is just ONE
        
        //count number of ","'s "bob, cindy, sam"
        let occurrenciesOfComma = RecipientLine.characters.filter { $0 == "," }.count
        if (occurrenciesOfComma > 0) {
            var pos: Int = 0
            var str = RecipientLine//"Hello.World"
            
            let needle: Character = ","
            
            if let idx = str.characters.index(of: needle) {
                pos = str.characters.distance(from: str.startIndex, to: idx)
                print("Found \(needle) at position \(pos)")
            }
            else {
                print("Not found")
            }
            
            let index = str.index(str.startIndex, offsetBy: pos)
            fromString = str.substring(to: index) + ", +\(occurrenciesOfComma) more"
                //sub.remove(at: sub.startIndex) //remove 1st char
            
        }
        
        return fromString
    }

    func getTokenThenInboxMessagesFromWebServer(){
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        // 0 get token again -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            //GET Inbox Messages---------------------
            self.getInboxMessagesFromDocumentsAPI(token:token)
            //-------------------------------------------------------
        }
    }
    
    func getInboxMessagesFromDocumentsAPI(token:String){
        
        
        let userProfile = UserDefaults.standard.object(forKey: "userProfile") as? Array<Dictionary<String,String>> ?? []
        if userProfile.isEmpty == false
        {
            let user = userProfile[0]
            let uid = user["User_ID"]!
            //print("userID: \(uid)")
            
            let inboxMessagesFlag = DispatchGroup()
            inboxMessagesFlag.enter()
            
            let newInboxMessages = GETInboxMessages()

            newInboxMessages.getInboxMessages(token: token, userID: uid, dispachInstance: inboxMessagesFlag)
            
            inboxMessagesFlag.notify(queue: DispatchQueue.main) {//inbox sent back from cloud
                //get docs and category and update filesTable-------------------
                self.restInbox = UserDefaults.standard.object(forKey: "RESTUserInbox") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
                
                if self.restInbox.isEmpty == false {
                    
                    self.inBoxSent.setTitle("Inbox (\(self.restInbox.count))", forSegmentAt: 0)
                    
                    
                }
                //var Iterator = 0
                //for message in self.restInbox {
                //    let from = self.returnNameTitle(userID:message["SendBy"]!)
                //    let sendBy = from["name"]! + ", " + from["title"]!
                //    self.restInbox[Iterator].updateValue(sendBy, forKey: "SendBy")
                    //
//                    //remove HTML tags
//                    let str = message["message"]!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                    self.restInbox[Iterator].updateValue(str, forKey: "message")
//                    
//                    //fix date 2017-05-25T19:14:31.000Z to 5/25/17 19:14 in table
//
//                    
//                    
               //     Iterator+=1
               // }
                self.inboxTable.reloadData()
                //-----------------------------
            }
        }
        
    }
    //To search the array for a particular key/value pair:
    

    
    func returnNameTitle(userID:String) -> Dictionary<String,String> {
        
        var name = userID//user["FirstLastName"]!
        var title = userID//user["RoleType"]!
        var isFound = false
        for recipient in recipients{
            if recipient["User_ID"] == userID {
                name = recipient["FirstLastName"]!
                title = recipient["RoleType"]!
                isFound = true
            }
        }
        if isFound == false {
                name = "Admin"
                title = "Administrator"
        }
        let dict = ["name":name,"title":title]
        
        return dict
        
    }
    
    func deleteMessageInAPI(messageId: String){
        
        print("ATTEMPT DELETE MESSAGE ID: \(messageId)")
//        ViewControllerUtils().showActivityIndicator(uiView: self.view)
//        
//        //Data---------------------
//
//        for recipient in restInbox{
//            recipients.append(Int(recipient["ID"]!)!)
//        }
//        //--------------------------
//        print("Subject:" + "\(messageAPIAtributes["Subject"]!)" + "\n" +
//            "Msg_desc:" + "\(messageAPIAtributes["Subject"]!)" + "\n" +
//            "SendBy:" + "\(messageAPIAtributes["SendBy"]!)" + "\n" +
//            "SendTo:" + "\(recipients)" )
//        
//        //set flag
//        let downloadTokenFlag = DispatchGroup()
//        downloadTokenFlag.enter()
//        
//        // 0 get token  -----------
//        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
//        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
//        
//        let getToken = GETToken()
//        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadTokenFlag)
//        
//        downloadTokenFlag.notify(queue: DispatchQueue.main)  {//signin API came back
//            
//            let token = UserDefaults.standard.string(forKey: "token")!
//            
//            let sendMessageFlag = DispatchGroup()
//            sendMessageFlag.enter()
//            
//            //Actual API call
//            let passMessageTo = POSTMessage()
//            passMessageTo.sendMessage(token: token, message: messageAPIAtributes, SendTo: recipients, dispachInstance: sendMessageFlag)
//            
//            sendMessageFlag.notify(queue: DispatchQueue.main) {//send message API came back
//                
//                ViewControllerUtils().hideActivityIndicator(uiView: self.view)
//                
//                if self.isKeyPresentInUserDefaults(key: "APIsendMessageSuccess") {
//                    let isMessageSentWithOutError = UserDefaults.standard.object(forKey: "APIsendMessageSuccess") as? Bool
//                    if isMessageSentWithOutError! {
//                        //success
//                        // ANIMATE  TOAST
//                        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
//                            
//                            self.view.makeToast("Message Sent", duration: 1.1, position: .center)
//                            
//                        }, completion: { finished in
//                            
//                            //Check if selected me
//                            //                let selectedName = "Jennifer Johnson"
//                            //
//                            //                // IF typedSubstring contains Selected, ignore
//                            //                let typedSubstring = self.addUsersTextField.text! //search
//                            //                if typedSubstring.range(of:selectedName) != nil {
//                            //                    //print("\(selectedName) already exists!")
//                            //
//                            //                    self.isMe = true
//                            //
//                            //                    self.appendNewMessageToInBoxData()
//                            //                }
//                            
//                            // Instantiate a view controller from Storyboard and present it
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
//                            self.present(vc, animated: false, completion: nil)
//                            
//                        })
//                    } else {
//                        //not success
//                        self.simpleAlert(title: "Error Sending Message", message: "API messaging error occured. Try again later.", buttonTitle: "OK")
//                        
//                        //                        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
//                        //
//                        //                            self.view.makeToast("Message Was Not Sent!", duration: 1.1, position: .center)
//                        //
//                        //                        }, completion: { finished in })
//                    }
//                }
//            }
//        }
        
        
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
        //self.performSegue(withIdentifier: "unwindToMainDB", sender: self)
        
        //Update 4/20/17 new home screen 
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }

    
    //
    // #MARK: - Search Functions
    //
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        searchBar.showsCancelButton = true
        searchBar.placeholder = ""
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        
        if(inBoxSent.selectedSegmentIndex == 0){
            searchBar.placeholder = "Search Inbox"
        } else {
            searchBar.placeholder = "Search Sent"
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        //alertSearchBar.endEditing(true)
    }

    

    //
    // MARK: - Table View
    //
    
    //[3] RETURN actual CELL to be displayed
    // SHOW SEGUE ->
    // " 1. click cell drag to second view. select the “show” segue in the “Selection Segue” section. "
    //http://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(restInbox.isEmpty == false){
            return restInbox.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell") as! InboxCell
        
        var Data:Dictionary<String,String> = restInbox[indexPath.row]//SearchData[indexPath.row]
        
//        let fullDateString = Data["CreatedDateTime"]!
//        var truncated = ""
//        var date = ""
//        if fullDateString.isEmpty == false {
//            date = self.convertDateStringToDate(longDate: fullDateString)
//            let startIndex = fullDateString.index(fullDateString.startIndex, offsetBy: 11)//Remove "2017-05-25T" 04:00 from "2017-05-25T04:00:00.000Z"
//            let truncatedFront = fullDateString.substring(from: startIndex)
//            
//            let endIndex = truncatedFront.index(truncatedFront.endIndex, offsetBy: -8)//Remove ":00.000Z"
//            truncated = truncatedFront.substring(to: endIndex)
//        }
//        
        let from = returnNameTitle(userID:Data["SendBy"]!)
        recipientsNameTitle.append(["name":from["name"]!,"title":from["title"]!])
        //let sendBy = from["name"]! + " " + from["title"]!
        
        //restInbox[indexPath.row].updateValue(sendBy, forKey: "SendBy")
        
        //var status = "false"
        //if Data["IsRead"]! != "" { status = Data["IsRead"]! }
//        let nameTitle = Data["SendBy"]!//bob smith, nurse
//        let token = nameTitle.components(separatedBy: ",")//token[0] "bob smith"
//        
//        let name = token[0]
//        let title = token[1]
        
        // Set text from the data model
        if( Data["IsRead"]! == "N"){
            cell.inboxStatusImage.image = UIImage(named: "orange.circle.png")
            cell.backgroundColor = UIColor.polar()
        } else {
            cell.inboxStatusImage.image = UIImage(named: "gray.circle.png")
            cell.backgroundColor = UIColor.white
        }
        cell.inboxFromTitle.text = from["title"]//Data["SendBy"]//title
        //if recipients > 1 show first recipients plus number of remaining recipients
        
        cell.inboxFromName.text = from["name"]//Data["SendBy"]//returnFirstRecipientNamePlusCountOfRemainingRecipients(RecipientLine: Data["recipient"]!)//= Data["recipient"]
        cell.inboxSubject.text = Data["Subject"]//"subject"
        cell.inboxMessageShort.text = Data["message"]
        cell.inboxDate.text = Data["CreatedDate"]//date
        cell.inboxTime.text = Data["CreatedTime"]//truncated//Data["time"]
        
         cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
        return cell
    
    }
    
    
    //DELETE row (the event) method
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //if (tableView == self.alertTableView)
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            //ATTEMPT to delete
            if Reachability.isConnectedToNetwork() == true
            { //print("Internet Connection Available!")
                
                //ATTEMP TO DELETE FROM API
                let aRecipient = restInbox[indexPath.row]
                deleteMessageInAPI(messageId: aRecipient["ID"]!)
                
                // Remove entire row from local storage
                restInbox.remove(at: (indexPath as NSIndexPath).row)
                
                
                // Reset Inbox and Sent Badge Numbers
                // NOTE SearchData = inBoxData if SEGMENT=0, =sentBoxData if SEG=1
                if( selectedSegmentIndexValue == 0 )
                {
                    //UserDefaults.standard.set(restInbox, forKey: "RESTUserInbox")
                    inBoxSent.setTitle("Inbox (\(restInbox.count))", forSegmentAt: 0)
                }
                if( selectedSegmentIndexValue == 1 )
                {
                    //UserDefaults.standard.set(sentBoxData, forKey: "sentData")
                    inBoxSent.setTitle("Sent (\(sentBoxData.count))", forSegmentAt: 1)
                }
                
                //UserDefaults.standard.synchronize()
                
                
                inboxTable.reloadData()
                
            } else {
                self.simpleAlert(title: "Error Deleting Message", message: "No Internet Connection.", buttonTitle: "OK")
            }
            
        }
    }
    
    //inBoxSent.selectedSegmentIndex segment 0 (Inbox) or 1 (Sent)
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "aMessageSegue" {
            
            let selectedRow = ((inboxTable.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
            
            var Data:Dictionary<String,String> = restInbox[selectedRow]
            let sentBy = recipientsNameTitle[selectedRow]//.append(["name":from["name"]!,"title":from["title"]!])
            // Mark this message as read
//                SearchData[selectedRow]["IsRead"] = "true"
//                if( selectedSegmentIndexValue == 0 )
//                {
//                    UserDefaults.standard.set(SearchData, forKey: "inBoxData")
//                }
//                if( selectedSegmentIndexValue == 1 )
//                {
//                    UserDefaults.standard.set(SearchData, forKey: "sentData")
//                }
            //inbox.append(["SendBy":s, "Subject":Subject, "message":message,
            //              "CreatedDateTime":CreatedDateTime, "IsRead":IsRead])
            
            if let toViewController = segue.destination as? /*1 sendTo AMessageViewController*/ AMessageViewController {
                /*maker sure .segueFromList is a var delaired in sendTo ViewController*/
                toViewController.segueFromList = sentBy["name"]//Data["SendBy"]//"Dr. Gary Webb"
                toViewController.segueDate = Data["CreatedDate"]!// + " " + Data["time"]! //"3/2/17 11:32 AM"
                toViewController.segueTime = Data["CreatedTime"]!
                toViewController.segueSubject = Data["Subject"]
                toViewController.segueMessage =  Data["message"]
                toViewController.segueSelectedRow = selectedRow
                if(inBoxSent.selectedSegmentIndex == 0){
                    toViewController.segueBoxSegmentString = "Inbox"
                } else {
                    toViewController.segueBoxSegmentString = "Sent"
                }
            }
            
        }
    }

    
    
    
    }




