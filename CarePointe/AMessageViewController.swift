//
//  AMessageViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 3/3/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class AMessageViewController: UIViewController {

    @IBOutlet weak var boxLabelButton: UIButton!
    @IBOutlet weak var fromToLabel: UILabel!
    @IBOutlet weak var fromListLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var message: UITextView!
    
    // from segue InboxViewController.swift
    var segueFromList: String!
    var segueDate: String!
    var segueTime: String!
    var segueSubject: String!
    var segueMessage:String!
    var segueSelectedRow: Int!
    var segueBoxSegmentString: String!
    
    var BoxData:Array<Dictionary<String, String>> = []
    //var boxSegmentString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set UI
            //SET box label (Inbox/Sent) and number of messages
            let boxCount = returnBoxCount(segmentString: segueBoxSegmentString)
            let boxSegmentString = segueBoxSegmentString + " (\(boxCount))"//self.returnStringFromDefaults(fKey:"boxSegment")
            boxLabelButton.setTitle(boxSegmentString, for: .normal)
        
            //Set Labels
            fromListLabel.text = segueFromList
            dateLabel.text = segueDate
            subjectLabel.text = "Subject: " + segueSubject
            message.text = segueMessage
        
            
        
        
    }

    //#MARK: - helper functions
    
//    func returnStringFromDefaults(fKey: String) -> String{
//        
//        boxSegmentString = UserDefaults.standard.string(forKey: "boxSegment") ?? "key boxSegment not in defaults"
//        let boxCount = returnBoxCount(segmentString: boxSegmentString) //?? "key boxSegment not in defaults"
//        
//        return boxSegmentString + " (\(boxCount))"
//    }
    
    func returnBoxCount(segmentString: String)->Int{
        var count = 0
        if( segmentString == "Inbox" )
        {
            BoxData = UserDefaults.standard.value(forKey: "RESTUserInbox") as! Array<Dictionary<String, String>>
            count = BoxData.count
        }
        if( segmentString == "Sent" )
        {
            BoxData = UserDefaults.standard.value(forKey: "sentData") as! Array<Dictionary<String, String>>
            count = BoxData.count
            fromToLabel.text = "To:"
        }
        
        return count
    }
    
    func displayAlertMessage(userMessage:String){
        
        let spacer = "\r\n"
        let alert = UIAlertController(title: userMessage, message: spacer, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default)
        { _ in
        
            // Remove entire row
            self.BoxData.remove(at: self.segueSelectedRow)
            
            
            // Update Defaults
            if(self.segueBoxSegmentString == "Inbox"){
                UserDefaults.standard.set(self.BoxData, forKey: "inBoxData")
            }
            if(self.segueBoxSegmentString == "Sent"){
                UserDefaults.standard.set(self.BoxData, forKey: "sentData")
            }
            UserDefaults.standard.synchronize()
            
            // Instantiate a view controller from Storyboard and present it
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
            self.present(vc, animated: false, completion: nil)
            
        })
        alert.addAction(UIAlertAction(title: "NO", style: .default) { _ in })
        
        present(alert, animated: true){}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Button Actions
    
    @IBAction func backBoxButtonTapped(_ sender: Any) {
        
        // Instantiate a view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        displayAlertMessage(userMessage:"Delete This Message?")
        
        
    }
    
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
    
    

}
