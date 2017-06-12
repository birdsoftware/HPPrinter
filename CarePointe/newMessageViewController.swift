//
//  newMessageViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/24/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class newMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate {


    //view
    @IBOutlet weak var topView: UIView!
    
    //buttons
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var attachFilesButton: UIButton!
    
    //text view
    @IBOutlet weak var messageBox: UITextView!
    
    //labels
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    //image view
    @IBOutlet weak var closeKeyboardButton: UIImageView!
    
    //text fields
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var addUsersTextField: UITextField!
    
    //tables
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var sendToList: UITableView!
    
    //constraints
    @IBOutlet weak var recipientsTopConstraint: NSLayoutConstraint!
    
    
    var AllData:Array<Dictionary<String,String>> = []
    var recipientsFromAPI:Array<Dictionary<String,String>> = []
    var recipientListForTable:Array<Dictionary<String,String>> = []//who we send to
    var uniqueValues = Set<String>()
    var SearchData:Array<Dictionary<String,String>> = []
    var search:String=""
    
    var sentBoxData:Array<Dictionary<String,String>> = []
    var recipientCount:Int = 0
    
    var isMe = false
    var inBoxData:Array<Dictionary<String,String>> = []
    
    //Segue from A Message Vars
    var isReply = false
    var segueFromList: Array<Dictionary<String,String>>! //recipientListForTable.append(["name":userName,"User_ID":selectedData["User_ID"]!])
    var segueDate: String!
    var segueSubject: String!
    var segueMessage:String!
    var segueUserID:String!
    var segueBACKStoryBoard: String!
    var segueBACKSBID: String!
    
    // Drop down list resources:
    //  http://www.iosinsight.com/uitextfield-drop-down-list-in-swift/
    // Getting/Setting Cursor Position:
    //  http://stackoverflow.com/questions/34922331/getting-and-setting-cursor-position-of-uitextfield-and-uitextview-in-swift
    
    // If user changes text, hide the tableView
    @IBAction func addUsersTextFieldChanged(_ sender: Any) {
        usersTableView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isKeyPresentInUserDefaults(key: "sentData"){
            sentBoxData = UserDefaults.standard.value(forKey: "sentData") as! Array<Dictionary<String, String>>
        }
        
        // get userData for communication drop down list
        if isKeyPresentInUserDefaults(key: "RESTInboxUsers"){//""userData"){
            recipientsFromAPI = UserDefaults.standard.value(forKey: "RESTInboxUsers") as! Array<Dictionary<String, String>>
            
        }
        
        for user in recipientsFromAPI{
            let userName = user["FirstLastName"]!
            let roleType = user["RoleType"]!
            let User_ID = user["User_ID"]!
            AllData.append(["pic":"user.png","name":userName,"position":roleType,"User_ID":User_ID])
        }
        
        SearchData = AllData//need this to start off tableView with all data and not blank table
        
        // UI
        toLabel.isHidden = true
        usersTableView.isHidden = true
        closeKeyboardButton.isHidden = true
        sendToList.layer.borderColor = UIColor(hex: 0x878687).cgColor
        sendToList.layer.borderWidth = 0.5
        recipientsTopConstraint.constant = 0
        
        //delegates - Tables
        usersTableView.delegate = self
        usersTableView.dataSource = self
        sendToList.delegate = self
        sendToList.dataSource = self
        
        //delegates
        addUsersTextField.delegate = self
        subjectTextField.delegate = self
        messageBox.delegate = self
        
        
        // Round
        sendButton.layer.cornerRadius = 0.5
        attachFilesButton.layer.cornerRadius = 0.5
        
        messageBox.layer.borderWidth = 1.0
        messageBox.layer.borderColor = UIColor.Iron().cgColor
        messageBox.layer.cornerRadius = 5
        
        //keyboard notification for show/hide closeKeyboardButton (x)
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow),
                           name: .UIKeyboardWillShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide),
                           name: .UIKeyboardWillHide,
                           object: nil)
        
        // New Reply? Do set up?
        if (isReply == true){// segueFromList.isEmpty == false

            for recipient in segueFromList{
                recipientListForTable.append(["name":recipient["name"]!,"User_ID":recipient["User_ID"]!])
                uniqueValues.insert(recipient["name"]!)
                
                switch uniqueValues.count {
                case 1,2:
                    recipientsTopConstraint.constant += 40
                case 3:
                    recipientsTopConstraint.constant += 20
                default: break
                }
            }
            toLabel.text = "To:(\(uniqueValues.count))"
            
            if uniqueValues.count > 0{
                toLabel.isHidden = false
            }
            
            print(recipientListForTable)//bug [["name": "Gabe Doc", "User_ID": "31"]] should be 351
            print(segueUserID)
            
            //addUsersTextField.text = segueFromList 123//fix this
            subjectTextField.text = segueSubject
            
            messageBox.text = segueMessage
            
            //place cursor in messageBox
            messageBox.becomeFirstResponder()
            
            //Set cursor position
            let newPosition = messageBox.beginningOfDocument
            messageBox.selectedTextRange = messageBox.textRange(from: newPosition, to: newPosition)
        }
    }
    
    
    @objc func keyboardWillShow(){
        closeKeyboardButton.isHidden = false
    }
    @objc func keyboardWillHide(){
        closeKeyboardButton.isHidden = true
    }
    
    
    // Manage keyboard and tableView visibility
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return
        }
        if touch.view != usersTableView
        {
            addUsersTextField.endEditing(true)
            usersTableView.isHidden = true
        }
        //if touch any part of the view (view controller) or the top close drop down list userTable
        if touch.view == self.view || touch.view == topView
        {
            usersTableView.isHidden = true
            addUsersTextField.endEditing(true)
            view.endEditing(true)
        }
        if(touch == addUsersTextField){
            usersTableView.isHidden = !usersTableView.isHidden
        }
        
    }
    
    // Toggle the tableView visibility when click on textField
        //    func addUsersTextFieldActive() {
        //            usersTableView.isHidden = !usersTableView.isHidden
        //    }
        //    func subjectTextFieldActive(){
        //        usersTableView.isHidden = true
        //    }
    
    
    
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
        let predicate=NSPredicate(format: "SELF.name CONTAINS[cd] %@", search)
        let arr=(AllData as NSArray).filtered(using: predicate)
        
        if arr.count > 0
        {
            SearchData.removeAll(keepingCapacity: true)
            SearchData=arr as! Array<Dictionary<String,String>>
        }
        else
        {
            SearchData=AllData
            recipientCount=0//
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
        
        addUsersTextField.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == subjectTextField){
            usersTableView.isHidden = true
        }
        if(textField == addUsersTextField){
            usersTableView.isHidden = false
        }
    }
    
    
    //
    //#MARK: Helper functions
    //
    
    func isUsersAdded() -> Bool {
        
        if (recipientListForTable.isEmpty) {
            return false
        }
            return true
    }
    
    
    func displayAlertMessage(userMessage:String){
        
        let spacer = "\r\n"
        let alert = UIAlertController(title: userMessage, message: spacer, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        
        present(alert, animated: true){}
    }
    
    func displayNoUserAlert(userMessage:String){
        
        let spacer = "\r\n"
        let alert = UIAlertController(title: userMessage, message: spacer, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in self.addUsersTextField.becomeFirstResponder()})//by setting first responder user is directed emediately to TextField after clicking OK button
        
        present(alert, animated: true){}
    }
    
    func sendNewMessageToAPI(){

        ViewControllerUtils().showActivityIndicator(uiView: self.view)
        
        //Data---------------------
        var messageAPIAtributes = Dictionary<String,String>()
        //let messageDataMissing = false
        
        /*let subject*/ messageAPIAtributes["Subject"] = subjectTextField.text!
        /*let message*/ messageAPIAtributes["Msg_desc"] = messageBox.text!
        //var User_ID = Int()
        if isKeyPresentInUserDefaults(key: "userProfile") {
            let userProfile = UserDefaults.standard.object(forKey: "userProfile") as? Array<Dictionary<String,String>> ?? []
            if userProfile.isEmpty == false {
                let user = userProfile[0]
                /*User_ID*/messageAPIAtributes["SendBy"] = user["User_ID"]!

            } else {
                //can't send a message. Your User id not found
                //messageDataMissing = true
            }
            
        }
        var recipients = [Int]()
        for recipient in recipientListForTable{
            recipients.append(Int(recipient["User_ID"]!)!)
        }
        //--------------------------
        print("Subject:" + "\(messageAPIAtributes["Subject"]!)" + "\n" +
            "Msg_desc:" + "\(messageAPIAtributes["Subject"]!)" + "\n" +
            "SendBy:" + "\(messageAPIAtributes["SendBy"]!)" + "\n" +
            "SendTo:" + "\(recipients)" )

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
            
            let sendMessageFlag = DispatchGroup()
            sendMessageFlag.enter()
            
            //Actual API call
            let passMessageTo = POSTMessage()
            passMessageTo.sendMessage(token: token, message: messageAPIAtributes, SendTo: recipients, dispachInstance: sendMessageFlag)
            
            sendMessageFlag.notify(queue: DispatchQueue.main) {//send message API came back
            
                ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                
                if self.isKeyPresentInUserDefaults(key: "APIsendMessageSuccess") {
                    let isMessageSentWithOutError = UserDefaults.standard.object(forKey: "APIsendMessageSuccess") as? Bool
                    if isMessageSentWithOutError! {
                        //success
                        // ANIMATE  TOAST
                        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
                            
                            self.view.makeToast("Message Sent", duration: 1.1, position: .center)
                            
                        }, completion: { finished in
                            
                            //Check if selected me
                            //                let selectedName = "Jennifer Johnson"
                            //
                            //                // IF typedSubstring contains Selected, ignore
                            //                let typedSubstring = self.addUsersTextField.text! //search
                            //                if typedSubstring.range(of:selectedName) != nil {
                            //                    //print("\(selectedName) already exists!")
                            //
                            //                    self.isMe = true
                            //
                            //                    self.appendNewMessageToInBoxData()
                            //                }
                            
                            // Instantiate a view controller from Storyboard and present it
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
                            self.present(vc, animated: false, completion: nil)
                            
                        })
                    } else {
                        //not success
                        self.simpleAlert(title: "Error Sending Message", message: "API messaging error occured. Try again later.", buttonTitle: "OK")
                        
                    }
                }
            }
        }
    }

    
    func appendNewMessageToInBoxData(){
        
        if isKeyPresentInUserDefaults(key: "inBoxData"){
            
            inBoxData = UserDefaults.standard.value(forKey: "inBoxData") as! Array<Dictionary<String, String>>
       
            let recipient = addUsersTextField.text!
            let subject = subjectTextField.text!
            let message = messageBox.text!
            
            let currentTime = returnCurrentDateOrCurrentTime(timeOnly: true)//4:41 PM
            let todaysDate = returnCurrentDateOrCurrentTime(timeOnly: false)//"2/14/2017"
            
            inBoxData.append(["recipient":recipient,"title":"Position","subject":subject,"message":message,"date":todaysDate,"time":currentTime,"isRead":"false"])
            UserDefaults.standard.set(inBoxData, forKey: "inBoxData")
            UserDefaults.standard.synchronize()
            
        }
    }

    
    //
    //#MARK: - Button Action
    //
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if segueBACKSBID != nil {
        if segueBACKSBID == "PatientTabBar" {
            //var segueBACKStoryBoard: String!
            //var segueBACKSBID: String!
            // Instantiate a view controller from Storyboard and present it
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: segueBACKSBID) as UIViewController
            self.present(vc, animated: false, completion: nil)
        }}
        
        // Instantiate a view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
        
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        if (isUsersAdded()) {
            
            if Reachability.isConnectedToNetwork() == true
            { //print("Internet Connection Available!")
                
                //ATTEMP TO SEND TO API
                self.sendNewMessageToAPI()
                
            } else {
                self.simpleAlert(title: "Error Sending Message", message: "No Internet Connection.", buttonTitle: "OK")
            }
            
        } else {//NO RECIPIENTS GET USER ATTENTION!
            
            addUsersTextField.backgroundColor = .peachCream()
            addUsersTextField.layer.borderWidth  = 1
            displayNoUserAlert(userMessage:"Please specify at least one recipient.")
        }

    }

    @IBAction func attachButtonTapped(_ sender: Any) {
//        let fileURL = Bundle.main.path(forResource: "Quotes", ofType: "png")
//        let documentController = UIDocumentInteractionController.init(URL: URL.init,
//            (fileURLWithPath: fileURL!))
//        documentController.presentOptionsMenuFromRect(self.button.frame, inView: self.view, animated: true)
        
    }
    
    
    //
    // MARK: UITableViewDataSource
    //
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == usersTableView {
            return SearchData.count
        } else {
            return recipientListForTable.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == usersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser") as! AddUsersCell
            
            var Data:Dictionary<String,String> = SearchData[indexPath.row]
            
            // Set text from the data model
            cell.userImage.image = /*UIImage(named: "user.png")*/UIImage(named: Data["pic"]!)
            cell.userName.text = /*"\(Data["FirstName"]!) \(Data["LastName"]!)"*/Data["name"]//! + " " + Data["User_ID"]!
            cell.userName?.font = addUsersTextField.font
            cell.userPosition.text = /*Data["RoleType"]*/Data["position"]
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipientsCell") as! RecipientsCell
            
            var Data:Dictionary<String,String> = recipientListForTable[indexPath.row]
            
            cell.name.text = Data["name"]
        
            return cell
        }
        
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == usersTableView {
            
            var selectedData:Dictionary<String,String> = SearchData[indexPath.row]
            let userName = selectedData["name"]!
            
            let beforeInsertCount = uniqueValues.count
            uniqueValues.insert(userName)
            let afterInsertCount = uniqueValues.count
            
            if beforeInsertCount != afterInsertCount {
                recipientListForTable.append(["name":userName,"User_ID":selectedData["User_ID"]!])
                
                switch uniqueValues.count {
                case 1,2:
                    recipientsTopConstraint.constant += 40
                case 3:
                    recipientsTopConstraint.constant += 20
                default: break
                }
                toLabel.text = "To:(\(uniqueValues.count))"
                
                if afterInsertCount > 0{
                    toLabel.isHidden = false
                }
            }
            
            sendToList.reloadData()
            
            //Check if selected me
    //        if(userName == "Jennifer Johnson"){//TODO:check user name saved from API
    //            isMe = true
    //        }
    //        
    //        // Row selected, so set textField to relevant value, hide tableView, endEditing can trigger some other action according to requirements
    //        if(addUsersTextField.text?.isEmpty == true) {
    //            
    //            addUsersTextField.text = userName
    //            //SearchData.remove(at: indexPath.row)
    //            recipientCount = 1
    //        } else {
    //            
    //            // No Remove what has been typed already
    //            let typedSubstring = addUsersTextField.text! //search
    //            //let selectedName = username//selectedData["name"]!
    //            
    //            // IF typedSubstring contains Selected, ignore
    //            if typedSubstring.range(of:userName) != nil {
    //                print("\(userName) already exists!")
    //            }
    //            else //typedSubstring !contains Selected, add Selected and remove anything !recipient
    //            {
    //                
    //                //remove typed substring if less than 1 recipient exists (selectedData)
    //                if (recipientCount < 1) {
    //                    //name exists in typed?
    //                    // Yes keep this name
    //                    var names: [String] = []
    //                    var isNameInUserTextField = false
    //                    
    //                    for dict in AllData { //thing is pic, name, position
    //                        guard let name = /*dict["FirstName"]*/ dict["name"] else { continue }
    //                        
    //                        if typedSubstring.range(of:name) != nil {//check if name is in the typedSubstring
    //                            isNameInUserTextField = true
    //                            names.append(name)
    //                        }
    //                    }
    //                    //Yes name found
    //                    let stringNames = names.joined(separator: ", ")
    //                    if(isNameInUserTextField)
    //                    {
    //                        addUsersTextField.text = stringNames  + ", " + userName// selectedData["name"]!
    //                    }
    //                    else {//No name so remove typed text
    //                        addUsersTextField.text = userName//selectedData["name"]! //there is a bug here if 1.type char, 2. select user, 3. type comma, 4. select user this user replaces recipient line
    //                    }
    //                }
    //                else {
    //                    addUsersTextField.text = addUsersTextField.text!  + ", " + userName//selectedData["name"]!
    //                }
    //                recipientCount += 1
    //            }
    //        }
                SearchData=AllData
                addUsersTextField.endEditing(true)
                usersTableView.reloadData()
                usersTableView.isHidden = true
            }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    //DELETE row (the event) method
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (tableView == self.sendToList) {
            if (editingStyle == .delete) {
                
                //remove from local array and set
                let recipientInSet = recipientListForTable[indexPath.row]
                recipientListForTable.remove(at: (indexPath as NSIndexPath).row)
                
                //move UI elements up
                switch uniqueValues.count {
                //case 0:
                    //toLabel.isHidden = true
                    //recipientsTopConstraint.constant -= 40
                case 1:
                    toLabel.isHidden = true
                    recipientsTopConstraint.constant -= 40
                case 2:
                    recipientsTopConstraint.constant -= 40
                case 3:
                    recipientsTopConstraint.constant -= 20
                default: break
                }
                
                //remove from set
                uniqueValues.remove(recipientInSet["name"]!)
                toLabel.text = "To:(\(uniqueValues.count))"

                sendToList.reloadData()
                
                
            }
        }
    }
    
}
