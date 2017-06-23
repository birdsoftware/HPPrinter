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
    var SearchData:Array<Dictionary<String,String>> = []
    var selectedSegmentIndexValue:Int = 0
    
    //API data
    var restInbox:Array<Dictionary<String,String>> = []
    var restSent:Array<Dictionary<String,String>> = []
    var recipients:Array<Dictionary<String,String>> = []
    var recipientsInboxNameTitle:Array<Dictionary<String,String>> = []
    var recipientsSentNameTitle:Array<Dictionary<String,String>> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getINandSENTMessagesFromWebServer()
        
        getLocalMessages(defaultKey: "RESTUserSent", arrayDicts: &restSent)
        
        getLocalMessages(defaultKey: "RESTUserInbox", arrayDicts: &restInbox)
        
        getLocalMessageUsers(defaultKey: "RESTInboxUsers", arrayDicts: &recipients)
        
        let countIn = restInbox.count
        inBoxSent.setTitle("Inbox (\(countIn))", forSegmentAt: 0)
        
        let countSent = restSent.count
        inBoxSent.setTitle("Sent (\(countSent))", forSegmentAt: 1)
        
        SearchData = restInbox          //-start  tableView with local INBOX messages
        
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
    
    
    @IBAction func inBoxSentSegmentSelected(_ sender: Any) {
        switch inBoxSent.selectedSegmentIndex
        {
        case 0:
            searchBar.placeholder = "Search Inbox"
            selectedSegmentIndexValue = 0
            SearchData = restInbox
            inboxTable.reloadData()
        case 1:
            searchBar.placeholder = "Search Sent"
            selectedSegmentIndexValue = 1
            SearchData = restSent
            inboxTable.reloadData()
        default:
            break;
        }
    }
    
    //
    // #MARK: - helper functions
    //
    func getLocalMessages(defaultKey: String, arrayDicts: inout Array<Dictionary<String,String>>){
        if isKeyPresentInUserDefaults(key: defaultKey){
        arrayDicts = UserDefaults.standard.object(forKey: defaultKey) as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
        }
        if arrayDicts.isEmpty == true {
        arrayDicts = [["SendBy":"", "Subject":"", "message":"",
        "CreatedDate":"", "CreatedTime":"", "IsRead":"", "ID":""]]
        }
    }
    func getLocalMessageUsers(defaultKey: String, arrayDicts: inout Array<Dictionary<String,String>>){
        if isKeyPresentInUserDefaults(key: defaultKey){
        arrayDicts = UserDefaults.standard.object(forKey: defaultKey) as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
        }
    }
    
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
        }
        
        return fromString
    }

    func getINandSENTMessagesFromWebServer(){
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        // 0 get token again -----------
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
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
            
            let sentMessagesFlag = DispatchGroup()
            sentMessagesFlag.enter()
            
            //INBOX
            GETInboxMessages().getInboxMessages(token: token, userID: uid, dispachInstance: inboxMessagesFlag)
            
            //SENT
            GETSentMessages().getSentMessages(token: token, userID: uid, dispachInstance: sentMessagesFlag)
            
            inboxMessagesFlag.notify(queue: DispatchQueue.main) {//inbox sent back from cloud
                //get docs and category and update filesTable-------------------
                self.restInbox = UserDefaults.standard.object(forKey: "RESTUserInbox") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
                
                if self.restInbox.isEmpty == false {
                    
                    self.inBoxSent.setTitle("Inbox (\(self.restInbox.count))", forSegmentAt: 0)
                }
                
                self.SearchData = self.restInbox
                self.inboxTable.reloadData()
            }
            
            sentMessagesFlag.notify(queue: DispatchQueue.main) {
                self.restSent = UserDefaults.standard.object(forKey: "RESTUserSent") as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
                
                if self.restSent.isEmpty == false {
            
                    self.inBoxSent.setTitle("Sent (\(self.restSent.count))", forSegmentAt: 1)
                }
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
    
    func deleteMessageInAPI(messageId: String, indexPathRow: Int, deleteInbox: Bool){
        
        print("ATTEMPT DELETE MESSAGE ID: \(messageId)")
        //ViewControllerUtils().showActivityIndicator(uiView: self.view)
        
        //set flag
        let downloadTokenFlag = DispatchGroup()
        downloadTokenFlag.enter()

        // 0 get token  -----------
        GETToken().signInCarepoint(dispachInstance: downloadTokenFlag)
        
        downloadTokenFlag.notify(queue: DispatchQueue.main)  {//signin API came back

            let token = UserDefaults.standard.string(forKey: "token")!

            let deleteMessageFlag = DispatchGroup()
            deleteMessageFlag.enter()

            //Actual API call
            var messageIds = [Int]()
            messageIds.append(Int(messageId)!)
            DeleteMessage().deleteMessage(token: token, messageIds: messageIds, dispachInstance: deleteMessageFlag)
            
            deleteMessageFlag.notify(queue: DispatchQueue.main) {//delete successful and API retuned back here
                
                //ViewControllerUtils().hideActivityIndicator(uiView: self.view)

                if self.isKeyPresentInUserDefaults(key: "APIdeleteMessageSuccess") {
                    let isMessageDeleteWithOutError = UserDefaults.standard.object(forKey: "APIdeleteMessageSuccess") as? Bool
                    if isMessageDeleteWithOutError! {
                        //success
                        // ANIMATE  TOAST
                        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
                            
                            self.view.makeToast("Message Deleted", duration: 1.1, position: .center)
                            
                        }, completion: { finished in
  
                            if deleteInbox == true {
                                // Remove entire row from local storage, reload table
                                self.restInbox.remove(at: (indexPathRow))
                                self.SearchData = self.restInbox
                                
                                self.inboxTable.reloadData()
                                
                                self.inBoxSent.setTitle("Inbox (\(self.restInbox.count))", forSegmentAt: 0)
                                
                                UserDefaults.standard.set(self.restInbox, forKey: "RESTUserInbox")
                                UserDefaults.standard.synchronize()
                                
                            } else {
                                self.restSent.remove(at: (indexPathRow))
                                self.SearchData = self.restSent
                                
                                self.inboxTable.reloadData()
                                
                                self.inBoxSent.setTitle("Sent (\(self.restSent.count))", forSegmentAt: 1)
                                
                                UserDefaults.standard.set(self.restSent, forKey: "RESTUserSent")
                                UserDefaults.standard.synchronize()
                            }
                            
                        })
                    } else {
                        //not success
                        self.simpleAlert(title: "Error Deleting Message", message: "API messaging error occured. Try again later.", buttonTitle: "OK")
                    }
                }
            }
        }
        
    }
    
    
    //
    // MARK: - Button Actions
    //
    
    @IBAction func goBackButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }

    
    //
    // #MARK: - Search Functions
    //
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let namePredicate = NSPredicate(format: "SELF.Patient_ID CONTAINS[cd] %@", searchText)
//        //TODO: the SendBy -> is Int id# from RESTUserInbox, SendTo -> Int from RESTUserSent
//        //need to convert this into name and title dictionary using returnNameTitle(userID:Data["SendBy"]!) in viewDidLoad
//    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        searchBar.endEditing(true)
        
        if(inBoxSent.selectedSegmentIndex == 0){
            searchBar.placeholder = "Search Inbox"
        } else {
            searchBar.placeholder = "Search Sent"
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    

    //
    // MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SearchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell") as! InboxCell
        var Data:Dictionary<String,String> = /*restInbox[indexPath.row]*/SearchData[indexPath.row]
        
        var from = Dictionary<String,String>()//
        
        if(inBoxSent.selectedSegmentIndex == 0){
            from = returnNameTitle(userID:Data["SendBy"]!)
            recipientsInboxNameTitle.append(["name":from["name"]!,"title":from["title"]!,"User_ID":Data["SendBy"]!]) //need for prepare for segue
        }
        if(inBoxSent.selectedSegmentIndex == 1){
            from = returnNameTitle(userID:Data["SendTo"]!)
            recipientsSentNameTitle.append(["name":from["name"]!,"title":from["title"]!,"User_ID":Data["SendTo"]!]) //need for prepare for segue
        }
        
        // Set text from the data model
        if( Data["IsRead"]! == "N"){
            cell.inboxStatusImage.image = UIImage(named: "orange.circle.png")
            cell.backgroundColor = UIColor.polar()
        } else {
            cell.inboxStatusImage.image = UIImage(named: "gray.circle.png")
            cell.backgroundColor = UIColor.white
            if(inBoxSent.selectedSegmentIndex == 1){
                //READ RECEIPT message was read
                cell.inboxStatusImage.image = UIImage(named: "doubleChecked.png")
            }
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
                var aRecipient = restInbox[indexPath.row] //get message id from inbox
                let isInboxDelete = true
                
                if(inBoxSent.selectedSegmentIndex == 1){
                    self.simpleAlert(title: "Deleting Sent Message", message: "Delete not available for sent messages yet.", buttonTitle: "OK")
//                    
//                    aRecipient = restSent[indexPath.row] //get message id from sent box
//                    isInboxDelete = false
//                    
                }
                if(inBoxSent.selectedSegmentIndex == 0){
                    deleteMessageInAPI(messageId: aRecipient["ID"]!, indexPathRow: indexPath.row, deleteInbox: isInboxDelete)
                }
  
            } else {
                self.simpleAlert(title: "Error Deleting Message", message: "No Internet Connection.", buttonTitle: "OK")
            }
            
        }
    }
    
    //
    // MARK: - Navigation
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "aMessageSegue" {
            
            let selectedRow = ((inboxTable.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
            
            var Data = Dictionary<String,String>()//restInbox[selectedRow]
            
            if(inBoxSent.selectedSegmentIndex == 0){
                
                Data = restInbox[selectedRow]
                
            }
            if(inBoxSent.selectedSegmentIndex == 1){
                
                Data = restSent[selectedRow]
                
            }
            
            if let toViewController = segue.destination as? /*1 sendTo AMessageViewController*/ AMessageViewController {
                /*maker sure .segueFromList is a var delaired in sendTo ViewController*/
                //Data["SendBy"]//"Dr. Gary Webb"
                toViewController.segueDate = Data["CreatedDate"]!// + " " + Data["time"]! //"3/2/17 11:32 AM"
                toViewController.segueTime = Data["CreatedTime"]!
                toViewController.segueSubject = Data["Subject"]
                toViewController.segueMessage =  Data["message"]
                toViewController.segueMessageID = Data["ID"]
                toViewController.segueIsRead = Data["IsRead"]!
                
                print("Data IsRead: \(Data["IsRead"]!)")
                
                toViewController.segueSelectedRow = selectedRow
                
                var sent = recipientsInboxNameTitle[selectedRow]
                
                if(inBoxSent.selectedSegmentIndex == 0){
                    
                    toViewController.segueBoxSegmentString = "Inbox"
                    
                    toViewController.segueBoxCount = restInbox.count
                    
                } else {
                    
                    sent = recipientsSentNameTitle[selectedRow]

                    toViewController.segueBoxSegmentString = "Sent"
                    
                    toViewController.segueBoxCount = restSent.count
                }
                
                var dict:Array<Dictionary<String,String>> = []
                dict.append(["name":sent["name"]!,"User_ID":sent["User_ID"]!])
                toViewController.segueFromList = dict //"name":userName,"User_ID":selectedData["User_ID"]!])
            }
        }
    }

    
    
    
    }




