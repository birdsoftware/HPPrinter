//
//  AlertsListVC.swift
//  CarePointe
//
//  Created by Brian Bird on 4/20/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class ConnectListVC: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{//, UITextFieldDelegate, UITextViewDelegate {

    // Buttons
    @IBOutlet weak var sendMessageButton: RoundedButton!
    @IBOutlet weak var videoConferenceButton: RoundedButton!
    
    // Table views
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var selectedUsereTableView: UITableView!
    
    
    // TextField
    @IBOutlet weak var addUsersTextField: UITextField!
    
    
    // Class search inBox varaibles
    var inboxUserList:Array<Dictionary<String,String>> = []
    var SearchData:Array<Dictionary<String,String>> = []
    var search:String=""
    
    var sendToList:[String] = []
    var recipientCount:Int = 0
    
    //Class selected users varaibles
    var selectedUsers:Array<Dictionary<String,String>> = []
    
    
    
    @IBAction func addUsersTextFieldChanged(_ sender: Any) {
            addUsersTextField.isHidden = false //show patient drop down list when keyboard char entered
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get userData for communication drop down list
        if isKeyPresentInUserDefaults(key: "RESTInboxUsers"){
            // "FirstLastName":firstLastName, "Company":company, "User_ID":uid, "RoleType":roleType -> POSITION
            inboxUserList = UserDefaults.standard.value(forKey: "RESTInboxUsers") as! Array<Dictionary<String, String>>//"userData") as!
        }

        //Table ROW Height set to auto layout
        selectedUsereTableView.rowHeight = UITableViewAutomaticDimension
        selectedUsereTableView.estimatedRowHeight = 100//was 88 and is 88 in storyboard
        
        // UI
        usersTableView.isHidden = true
        sendMessageButton.isHidden = true
        videoConferenceButton.isHidden = true
        
        //delegates
        usersTableView.delegate = self
        usersTableView.dataSource = self
        addUsersTextField.delegate = self
        
        selectedUsereTableView.delegate = self
        selectedUsereTableView.dataSource = self
        
        //Fill blank table with inboxUserList when we first load view
        //SearchData = inboxUserList
    }
    
    
    //
    // MARK: Manage Keyboard & tableView visability
    //
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch:UITouch = touches.first else
        {
            return
        }
        if touch.view != usersTableView //if you didn't touch the table but something else, close table and keyboard
        {
            addUsersTextField.text = ""
            usersTableView.isHidden = true
            addUsersTextField.endEditing(true)
            view.endEditing(true)
        }
        if(touch == addUsersTextField){
           // usersTableView.isHidden = !usersTableView.isHidden
        }
    }
    
    
    //
    //#MARK: - Search Recipients
    //
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            search = String(search.characters.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        
        print("search: \(search)")
        let predicate=NSPredicate(format: "SELF.FirstLastName CONTAINS[cd] %@", search) // search only returns .FirstLastName from inboxUserList["FirstLastName"]
        let arr=(inboxUserList as NSArray).filtered(using: predicate)
        
        if arr.count > 0
        {
            SearchData.removeAll(keepingCapacity: true)
            SearchData=arr as! Array<Dictionary<String,String>>
            usersTableView.isHidden = false
        }
        else
        {
            SearchData.removeAll(keepingCapacity: true)
            usersTableView.isHidden = true
        }

        usersTableView.reloadData()
        return true
    }
    
    
    //
    // MARK: UITextFieldDelegate
    //
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Your app can do something when textField finishes editing
        print("The textField ended editing. Do something based on app requirements.")
         usersTableView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == addUsersTextField){
           // usersTableView.isHidden = false
        }
    }
    
    
    //
    // MARK: Buttons
    //
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        //SEE prepare(for segue: UIStoryboardSegue, sender: Any?) BELOW
    }
    
    @IBAction func videoConferenceButtonTapped(_ sender: Any) {
        if(selectedUsers.count > 2){
            simpleAlert(title: "Alert", message: "Can't video conference more than 2 users. Try again with two or fewer users.", buttonTitle: "OK")
        }
        if(selectedUsers.isEmpty){
            simpleAlert(title: "Alert", message: "No users selcted. Try again with one or more users.", buttonTitle: "OK")
        } else if selectedUsers.count < 3{
            
            self.performSegue(withIdentifier: "teleConnectSegue", sender: self)
            
        }
    }
    
    @IBAction func callCarePointButtonTapped(_ sender: Any) {
        
        open(scheme: "tel://4804942466")
        
    }
    
    
    
    
    //
    // MARK: UITableViewDataSource
    //
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //selectedUsereTableView
        if(tableView == usersTableView){
            return SearchData.count
        } else {
            return selectedUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == usersTableView){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser2") as! AddUsers2Cell
            
            var Data:Dictionary<String,String> = SearchData[indexPath.row]
            let usersPhone = Data["phone_number"]!
            
            // Set text from the data model
            cell.userImage.image = UIImage(named: "user.png")//UIImage(named: Data["pic"]!)
            cell.userName.text = Data["FirstLastName"]! + returnPhoneEmoji(phoneNumber: usersPhone) + usersPhone
            cell.userName?.font = addUsersTextField.font
            cell.userPosition.text = "Roll: " + Data["RoleType"]!
            cell.userCompany.text = "Company: " + Data["Company"]!
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser3") as! AddUsers3Cell
            
            var Data:Dictionary<String,String> = selectedUsers[indexPath.row]
            let usersPhone = Data["phone_number"]!
            
            cell.userName.text = Data["FirstLastName"]!  + returnPhoneEmoji(phoneNumber: usersPhone) + usersPhone
            cell.userPositionCompany.text = "Roll: " + Data["RoleType"]! + " | Company: " + Data["Company"]!
            cell.callButton.tag = indexPath.row //set tag of the button
            
            //if userHasPhone(phoneString: usersPhone) {
               // cell.callButton.addTarget(self, action: #selector(connected), for: .touchUpInside)
            //} else {
            //    cell.callButton.setImage(nil, for: .normal)
            //    cell.callButton.backgroundColor = .white
            //    cell.callButton.setTitle(returnPhoneEmoji(phoneNumber: usersPhone), for: .normal)
           // }
            cell.callButton.tag = indexPath.row //tag is Int -2,147,483,648 and 2,147,483,647  7,025,409,696
            cell.callButton.addTarget(self, action: #selector(connected), for: .touchUpInside)
            
            return cell
        }
    }
    
    func connected(sender: UIButton) {
        
        //get the tag in this connected function
        let buttonTag = sender.tag
        //call care team member
        //callCareTeamMember(member: buttonTag)
        
        let selectedUserData:Dictionary<String,String> = selectedUsers[buttonTag] //FirstLastName,phone_number,RoleType,Company
        var phoneString = selectedUserData["phone_number"]!
        phoneString = phoneString.replacingOccurrences(of: "(", with: "")
        phoneString = phoneString.replacingOccurrences(of: ")", with: "")
        phoneString = phoneString.replacingOccurrences(of: "-", with: "")
        
        open(scheme: "tel://\(phoneString)")
        //open(scheme: "tel://8556235691")
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if(tableView == usersTableView){//if you select usersTableView do this
            
            //close table, clear addUsersTextField and close keyboard
            addUsersTextField.text = ""
            usersTableView.isHidden = true
            addUsersTextField.endEditing(true)
            
            //show send message and video Buttons
            sendMessageButton.isHidden = false
            videoConferenceButton.isHidden = false
            
            var selectedData:Dictionary<String,String> = SearchData[indexPath.row]
            let userN = selectedData["FirstLastName"]!
            let phone = selectedData["phone_number"]!
            let roll = selectedData["RoleType"]!
            let co = selectedData["Company"]!
            
            //
            //DO NOT ADD DUPLICATES
            //
            let isDuplicate = arrayContains(array: selectedUsers, key: "FirstLastName", value: userN)
            
            if(isDuplicate == false) {
                selectedUsers.append(["FirstLastName":userN,"phone_number": phone, "RoleType":roll,"Company":co])
                selectedUsereTableView.reloadData()
            }
            
        }
    }
    
    //DELETE row (the event) method
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (tableView == selectedUsereTableView) {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                //remove from local array
                selectedUsers.remove(at: (indexPath as NSIndexPath).row)
                selectedUsereTableView.reloadData()
            }
        }
        if(selectedUsers.isEmpty){
            videoConferenceButton.isHidden = true
            sendMessageButton.isHidden = true
        }
    }
   
    
    //
    // # MARK: Support functions
    //
    
    func returnPhoneEmoji(phoneNumber: String ) -> String{
        let phoneEmoji = " \u{1F4F1}"
        let noPhoneEmoji = " \u{1F4F5}"
        
        if userHasPhone(phoneString: phoneNumber) {
            return phoneEmoji
        } else {
            return noPhoneEmoji
        }
    }
    
    func userHasPhone(phoneString: String) -> Bool{
        
        if(phoneString == ""){
            return false
        } else {
            return true
        }
    }

    //search array of dictionaries for particular key/value pair
    func arrayContains(array:[[String:String]], key: String, value: String) -> Bool {
        for dict in array {
            if dict[key] == value {
                return true
            }
        }
        return false
    }

    
    
//
// # MARK: Supports CALL
//
    
    
    
    //open(scheme: "tel://4804942466")
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "replyMessageSegue" {
            //segue out varaibles
            var recipientList = ""
            for user in selectedUsers{
                let userName = user["FirstLastName"]!
                recipientList = recipientList + " \(userName),"
            }
            
            let currentTime = returnCurrentDateOrCurrentTime(timeOnly: true)//4:41 PM
            let todaysDate = returnCurrentDateOrCurrentTime(timeOnly: false)//"2/14/2017"
            
            if let toViewController = segue.destination as? /*1 sendTo AMessageViewController*/ newMessageViewController {
                /*maker sure .segueFromList is a var delaired in sendTo ViewController*/
                toViewController.isReply = true
                toViewController.segueFromList = recipientList//segueFromList
                toViewController.segueDate = todaysDate + " " + currentTime //"3/2/17 11:32 AM"
                toViewController.segueSubject = ""// + segueSubject
                toViewController.segueMessage =  ""//"\n>" + segueMessage
            }
            
        }
        if segue.identifier == "teleConnectSegue" {
            
        }
    }

}


