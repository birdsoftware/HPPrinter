//
//  AMessageViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 3/3/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class AMessageViewController: UIViewController {

    //button
    @IBOutlet weak var boxLabelButton: UIButton!
    
    //labels
    @IBOutlet weak var fromToLabel: UILabel!
    @IBOutlet weak var fromListLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var wasReadText: UILabel!
    
    @IBOutlet weak var wasReadIcon: UIImageView!
    //text view
    @IBOutlet weak var message: UITextView!

    
    // from segue InboxViewController.swift
    var segueFromList: Array<Dictionary<String,String>>! //recipientListForTable.append(["name":userName,"User_ID":selectedData["User_ID"]!])
    var segueDate: String!
    var segueTime: String!
    var segueSubject: String!
    var segueMessage:String!
    var segueSelectedRow: Int!
    var segueBoxSegmentString: String!
    var segueMessageID: String! //for isRead == Y
    var segueBoxCount: Int!
    var segueIsRead: String!
    
    var messageIsInbox = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set UI
            //SET box label (Inbox/Sent) and number of messages
            //let boxCount = returnBoxCount(segmentString: segueBoxSegmentString)
            let boxSegmentString = segueBoxSegmentString + " (\(segueBoxCount!))"//self.returnStringFromDefaults(fKey:"boxSegment")
            boxLabelButton.setTitle(boxSegmentString, for: .normal)
        wasReadIcon.isHidden = true
        wasReadText.isHidden = true
        
        print(segueFromList)
        
            //Set Labels
        var nameList = ""
        for recipient in segueFromList{
            nameList = nameList + recipient["name"]!
        }
            fromListLabel.text = nameList//segueFromList
            dateLabel.text = segueDate
            subjectLabel.text = "Subject: " + segueSubject
            message.text = segueMessage
        
        //UPDATE Message isRead == "Y" only for Inbox not Sent. Sent messages get isRead changed to "Y" when the recipient reads the message.
        if segueBoxSegmentString == "Inbox"{
            messageIsInbox = true
            upDateMessageIsReadIsTrue()//for segueMessageID
        } else {
            fromLabel.text = "To: "
            if segueIsRead == "Y"
            {
                wasReadIcon.isHidden = false
                wasReadText.isHidden = false
            }
        }
        

    }

    //
    //#MARK: - helper functions
    //
    
    func upDateMessageIsReadIsTrue(){
        
        //Get token first
        
        //set flag
        let downloadTokenFlag = DispatchGroup()
        downloadTokenFlag.enter()
        
        // 0 GET token  -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadTokenFlag)
        
        downloadTokenFlag.notify(queue: DispatchQueue.main)  {//signin API came back
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            let iSReadMessageFlag = DispatchGroup()
            iSReadMessageFlag.enter()
            
            //Actual API call for segueMessageID
        
            UserRead().MessageID(token: token, messageId: self.segueMessageID, dispachInstance: iSReadMessageFlag)
            
            iSReadMessageFlag.notify(queue: DispatchQueue.main) {//isRead successful from server
                //Do somehting now
                
            }
        }
        
    }
    
//    func returnStringFromDefaults(fKey: String) -> String{
//        
//        boxSegmentString = UserDefaults.standard.string(forKey: "boxSegment") ?? "key boxSegment not in defaults"
//        let boxCount = returnBoxCount(segmentString: boxSegmentString) //?? "key boxSegment not in defaults"
//        
//        return boxSegmentString + " (\(boxCount))"
//    }
    
//    func returnBoxCount(segmentString: String)->Int{
//        var count = 0
//        if( segmentString == "Inbox" )
//        {
//            BoxData = UserDefaults.standard.value(forKey: "RESTUserInbox") as! Array<Dictionary<String, String>>
//            count = BoxData.count
//        }
//        if( segmentString == "Sent" )
//        {
//            BoxData = UserDefaults.standard.value(forKey: "sentData") as! Array<Dictionary<String, String>>
//            count = BoxData.count
//            fromToLabel.text = "To:"
//        }
//        
//        return count
//    }
    
    func displayDeleteAlertMessage(userMessage:String){
        
        let spacer = "\r\n"
        let alert = UIAlertController(title: userMessage, message: spacer, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default)
        { _ in
        
            // Remove entire row
            //self.BoxData.remove(at: self.segueSelectedRow)
            
            self.deleteMessageInAPI(messageId: self.segueMessageID, indexPathRow: self.segueSelectedRow)
            
            // Instantiate a view controller from Storyboard and present it
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
            self.present(vc, animated: false, completion: nil)
            
        })
        alert.addAction(UIAlertAction(title: "NO", style: .default) { _ in })
        
        present(alert, animated: true){}
    }
    
    func deleteMessageInAPI(messageId: String, indexPathRow: Int){
        
        print("ATTEMPT DELETE MESSAGE ID: \(messageId)")
        //ViewControllerUtils().showActivityIndicator(uiView: self.view)
        
        //set flag
        let downloadTokenFlag = DispatchGroup()
        downloadTokenFlag.enter()
        
        // 0 get token  -----------
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadTokenFlag)
        
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
                            
                            
//                            // Remove entire row from local storage, reload table
//                            self.restInOrSentBox.remove(at: (indexPathRow))
//
//                            if self.deleteInbox == true {
//                                
//                                UserDefaults.standard.set(self.restInOrSentBox, forKey: "RESTUserInbox")
//                                UserDefaults.standard.synchronize()
//                                
//                            } else {
//                                
//                                UserDefaults.standard.set(self.restInOrSentBox, forKey: "RESTUserSent")
//                                UserDefaults.standard.synchronize()
//                            }
                            
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
    @IBAction func backBoxButtonTapped(_ sender: Any) {
        
        // Instantiate a view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        displayDeleteAlertMessage(userMessage:"Delete This Message?")
        
        
    }
    
    //
    // #MARK: - Prepare for Segue
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "replyMessageSegue" {
            
            //let selectedRow = ((inboxTable.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
            //var Data:Dictionary<String,String> = SearchData[selectedRow]
            
            
            if let toViewController = segue.destination as? /*1 sendTo AMessageViewController*/ newMessageViewController {
                /*maker sure .segueFromList is a var delaired in sendTo ViewController*/
                toViewController.isReply = true
                toViewController.segueFromList = segueFromList
                toViewController.segueDate = segueDate //"3/2/17 11:32 AM"
                toViewController.segueSubject = "Re: " + segueSubject
                toViewController.segueMessage =  "\n>" + segueMessage
            }
            
        }
    }
    
    //for recipient in segueFromList{
    //recipientListForTable.append(["name":recipient["name"]!,"User_ID":recipient["User_ID"]!])

}
