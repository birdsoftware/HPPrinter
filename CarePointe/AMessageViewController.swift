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
    @IBOutlet weak var fromListLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var message: UITextView!
    
    var segueFromList: String!
    var segueDate: String!
    var segueSubject: String!
    var segueMessage:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set UI
            //SET box label (Inbox/Sent) and number of messages
            let boxSegmentString = self.returnStringFromDefaults(fKey:"boxSegment")
            boxLabelButton.setTitle(boxSegmentString, for: .normal)
        
            //Set Labels
            fromListLabel.text = segueFromList
            dateLabel.text = segueDate
            subjectLabel.text = segueSubject
            message.text = segueMessage
        
    }

    //#MARK: - helper functions
    
    func returnStringFromDefaults(fKey: String) -> String{
        
        let boxSegmentString = UserDefaults.standard.string(forKey: "boxSegment") ?? "key boxSegment not in defaults"
        let boxCount = returnBoxCount(segmentString: boxSegmentString) //?? "key boxSegment not in defaults"
        
        return boxSegmentString + " (\(boxCount))"
    }
    
    func returnBoxCount(segmentString: String)->Int{
        var count = 0
        if( segmentString == "Inbox" )
        {
            let BoxData = UserDefaults.standard.value(forKey: "inBoxData") as! Array<Dictionary<String, String>>
            count = BoxData.count
        }
        if( segmentString == "Sent" )
        {
            let BoxData = UserDefaults.standard.value(forKey: "sentData") as! Array<Dictionary<String, String>>
            count = BoxData.count
        }
        
        return count
    }
    
    func displayAlertMessage(userMessage:String){
        
        let spacer = "\r\n"
        let alert = UIAlertController(title: userMessage, message: spacer, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default) { _ in })
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
    
    
    
    

}
