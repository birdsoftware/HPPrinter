//
//  InboxViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/21/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var newEmailButton: RoundedButton!
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // default segment displayed is inbox, save that to defaults
        UserDefaults.standard.set("Inbox", forKey: "boxSegment")
        UserDefaults.standard.synchronize()
        
        if isKeyPresentInUserDefaults(key: "inBoxData"){
            inBoxData = UserDefaults.standard.value(forKey: "inBoxData") as! Array<Dictionary<String, String>>
            inBoxSent.setTitle("Inbox (\(inBoxData.count))", forSegmentAt: 0)
        } else {
            inBoxSent.setTitle("Inbox (\(0))", forSegmentAt: 0)
        }
        if isKeyPresentInUserDefaults(key: "sentData"){
            sentBoxData = UserDefaults.standard.value(forKey: "sentData") as! Array<Dictionary<String, String>>
            inBoxSent.setTitle("Sent (\(sentBoxData.count))", forSegmentAt: 1)
        } else {
            inBoxSent.setTitle("Sent (\(0))", forSegmentAt: 1)
        }
        
        SearchData = inBoxData//need this to start off tableView with all data and not blank table

        // Setup UI/UX
            //round careTeam button
                newEmailButton.layer.cornerRadius = 0.5 * newEmailButton.bounds.size.width
                newEmailButton.clipsToBounds = true
                //newEmailButton.layer.borderWidth = 1.0
                //newEmailButton.layer.borderColor = UIColor.white.cgColor
                //scale button down
                newEmailButton.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        
        // Setup sement control font and font size
                let attr = NSDictionary(object: UIFont(name: "Futura", size: 16.0)!, forKey: NSFontAttributeName as NSCopying)
                UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        
        //delegates
            inboxTable.delegate = self
            inboxTable.dataSource = self
            searchBar.delegate = self
    }

    
    // UI Segment Control
    
    @IBAction func inBoxSentSegmentSelected(_ sender: Any) {
        switch inBoxSent.selectedSegmentIndex
        {
        case 0:
            UserDefaults.standard.set("Inbox", forKey: "boxSegment")
            UserDefaults.standard.synchronize()
            searchBar.placeholder = "Search Inbox"
            selectedSegmentIndexValue = 0
            if isKeyPresentInUserDefaults(key: "inBoxData") {
                inBoxData = UserDefaults.standard.value(forKey: "inBoxData") as! Array<Dictionary<String, String>>
            }
            SearchData = inBoxData
            inboxTable.reloadData()
        case 1:
            UserDefaults.standard.set("Sent", forKey: "boxSegment")
            UserDefaults.standard.synchronize()
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
    
    
    
    
    // helper functions
    
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
        if(SearchData.isEmpty == false){
            return SearchData.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell") as! InboxCell
        
        var Data:Dictionary<String,String> = SearchData[indexPath.row]
        
        let status:String = Data["isRead"]!
        
        
        // Set text from the data model
        if( status == "false"){
            cell.inboxStatusImage.image = UIImage(named: "orange.circle.png")
            cell.backgroundColor = UIColor.polar()
        } else {
            cell.inboxStatusImage.image = UIImage(named: "gray.circle.png")
            cell.backgroundColor = UIColor.white
        }
        cell.inboxFromTitle.text = Data["title"]
        //if recipients > 1 show first recipients plus number of remaining recipients
        
        cell.inboxFromName.text = returnFirstRecipientNamePlusCountOfRemainingRecipients(RecipientLine: Data["recipient"]!)//= Data["recipient"]
        cell.inboxSubject.text = Data["subject"]
        cell.inboxMessageShort.text = Data["message"]
        cell.inboxDate.text = Data["date"]
        cell.inboxTime.text = Data["time"]
        
         cell.accessoryType = .disclosureIndicator // add arrow > to cell
        
        return cell
    
    }
    
    
    //DELETE row (the event) method
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //if (tableView == self.alertTableView)
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // Remove entire row
            SearchData.remove(at: (indexPath as NSIndexPath).row)

            
            // Reset Inbox and Sent Badge Numbers
            // NOTE SearchData = inBoxData if SEGMENT=0, =sentBoxData if SEG=1
            if( selectedSegmentIndexValue == 0 )
            {
                UserDefaults.standard.set(SearchData, forKey: "inBoxData")
                inBoxSent.setTitle("Inbox (\(SearchData.count))", forSegmentAt: 0)
            }
            if( selectedSegmentIndexValue == 1 )
            {
                UserDefaults.standard.set(SearchData, forKey: "sentData")
                inBoxSent.setTitle("Sent (\(SearchData.count))", forSegmentAt: 1)
            }
            
            UserDefaults.standard.synchronize()
            
            
            inboxTable.reloadData()
        }
    }
    
    //inBoxSent.selectedSegmentIndex segment 0 (Inbox) or 1 (Sent)
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "aMessageSegue" {
            
            let selectedRow = ((inboxTable.indexPathForSelectedRow as NSIndexPath?)?.row)! //returns int
            var Data:Dictionary<String,String> = SearchData[selectedRow]
            
            // Mark this message as read ,"isRead":"true"
                SearchData[selectedRow]["isRead"] = "true"
                if( selectedSegmentIndexValue == 0 )
                {
                    UserDefaults.standard.set(SearchData, forKey: "inBoxData")
                }
                if( selectedSegmentIndexValue == 1 )
                {
                    UserDefaults.standard.set(SearchData, forKey: "sentData")
                }

            
            if let toViewController = segue.destination as? /*1 sendTo AMessageViewController*/ AMessageViewController {
                /*maker sure .segueFromList is a var delaired in sendTo ViewController*/
                toViewController.segueFromList = Data["recipient"]//"Dr. Gary Webb"
                toViewController.segueDate = Data["date"]! + " " + Data["time"]! //"3/2/17 11:32 AM"
                toViewController.segueSubject = Data["subject"]
                toViewController.segueMessage =  Data["message"]
                toViewController.segueSelectedRow = selectedRow
            }
            
        }
    }

    
    
    
    }




