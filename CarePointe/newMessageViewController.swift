//
//  newMessageViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/24/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class newMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var alertMessageLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var attachFilesButton: UIButton!
    @IBOutlet weak var messageBox: UITextView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var closeKeyboardButton: UIImageView!
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var addUsersTextField: UITextField!
    
    @IBOutlet weak var usersTableView: UITableView!
    
    var AllData:Array<Dictionary<String,String>> = []
    var SearchData:Array<Dictionary<String,String>> = []
    var search:String=""
    
    var sentBoxData:Array<Dictionary<String,String>> = []
    var sendToList:[String] = []
    var recipientCount:Int = 0
    
    var isMe = false
    var inBoxData:Array<Dictionary<String,String>> = []
    
    //Segue from A Message Vars
    var isReply = false
    var segueFromList: String!
    var segueDate: String!
    var segueSubject: String!
    var segueMessage:String!
    
    // Drop down list resources:
    //  http://www.iosinsight.com/uitextfield-drop-down-list-in-swift/
    // Getting/Setting Cursor Position:
    //  http://stackoverflow.com/questions/34922331/getting-and-setting-cursor-position-of-uitextfield-and-uitextview-in-swift

    let blueColor = [NSForegroundColorAttributeName: UIColor.blue] as [String : Any]
    let cellReuseIdentifier = "cell"
    
    // If user changes text, hide the tableView
    @IBAction func addUsersTextFieldChanged(_ sender: Any) {
        usersTableView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isKeyPresentInUserDefaults(key: "sentData"){
            sentBoxData = UserDefaults.standard.value(forKey: "sentData") as! Array<Dictionary<String, String>>
        }

        AllData = [["pic":"Alice.png","name":"Alice Smith","position":"Nurse"],
                   ["pic":"brad.png","name":"Brad Smith MD","position":"Primary Doctor"],
                   ["pic":"user.png","name":"Dr. Quam","position":"Immunologist"],
                   ["pic":"jennifer.jpg","name":"Jennifer Johnson","position":"Case Manager"],
                   ["pic":"user.png","name":"John Banks MD","position":"Cardiologist"],
                   ["pic":"tammie.png","name":"Tammie Summers","position":"Case Manager"],
                   ]
        
        SearchData = AllData//need this to start off tableView with all data and not blank table
        
        // UI
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.isHidden = true
        closeKeyboardButton.isHidden = true
        
        //delegates
        addUsersTextField.delegate = self
        subjectTextField.delegate = self
        messageBox.delegate = self
        
        // Round userImage
        userImage.layer.cornerRadius = 0.5 * userImage.bounds.size.width
        userImage.clipsToBounds = true
        updateToSavedImage(Userimage: userImage)
        sendButton.layer.cornerRadius = 0.5
        attachFilesButton.layer.cornerRadius = 0.5
        
        messageBox.layer.borderWidth = 1.0
        messageBox.layer.borderColor = UIColor.Iron().cgColor
        messageBox.layer.cornerRadius = 5
        
        alertMessageLabel.layer.masksToBounds = true
        alertMessageLabel.layer.cornerRadius = 5
        alertMessageLabel.text = ""
        
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
        if (isReply == true){//segueFromList.isEmpty == false) {

            addUsersTextField.text = segueFromList
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
        
        print(search)
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
        
        //remove crap from addUsersTextField.text ONLY DO if !addUsersTextField.text?.isEmpty
        let recipientLine = addUsersTextField.text!
        //let availableRecipients = AllData["name"]! //"name"
        
        let occurrenciesOfComma = recipientLine.characters.filter { $0 == "," }.count
        
        if (occurrenciesOfComma > 0) {//bob,...
            
            var position: Int = 0
            let needle: Character = ","
            
            if let idx = recipientLine.characters.index(of: needle) {
                
                position = recipientLine.characters.distance(from: recipientLine.startIndex, to: idx)
                print("Found \(needle) at position \(position)")
                let index = recipientLine.index(recipientLine.startIndex, offsetBy: position)
                let posibleRecipient = recipientLine.substring(to: index)
                                                //CONTAINS[cd]
                let predicate=NSPredicate(format: "SELF.name = %@", posibleRecipient)
                let arr=(AllData as NSArray).filtered(using: predicate) // arr only returns AllData["name"] == posibleRecipient
                print("posibleRecipient:\(posibleRecipient)")
                print("arr:\(arr)")
                // Remove what has been typed already
             //   let typedSubstring = addUsersTextField.text! //search
            //    let selectedName = selectedData["name"]!
                
                // IF typedSubstring contains Selected, ignore
             //   if typedSubstring.range(of:selectedName) != nil {
             //       print("\(selectedName) already exists!")
             //   }
            }
            else {
                print("Not found")
            }
            
        }
        
        
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
        
        if (addUsersTextField.text?.isEmpty)! {
            return false
        }
            return true
    }
    
    
    func displayAlertMessage(userMessage:String){
        
        let spacer = "\r\n"
        let alert = UIAlertController(title: userMessage, message: spacer, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width:40, height:40))
        //        imageView.contentMode = UIViewContentMode.center
        //        imageView.image = UIImage(named: "checked.png")
        //alert.view.addSubview(imageView)
        
        present(alert, animated: true){}
    }
    
    func displayNoUserAlert(userMessage:String){
        
        let spacer = "\r\n"
        let alert = UIAlertController(title: userMessage, message: spacer, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in self.addUsersTextField.becomeFirstResponder()})//by setting first responder user is directed emediately to TextField after clicking OK button
        
        present(alert, animated: true){}
    }
    
    func appendNewMessageToSentBoxData(){

        let recipient = addUsersTextField.text!
        let subject = subjectTextField.text!
        let message = messageBox.text!
        
        let currentTime = returnCurrentDateOrCurrentTime(timeOnly: true)//4:41 PM
        let todaysDate = returnCurrentDateOrCurrentTime(timeOnly: false)//"2/14/2017"
        
        sentBoxData.append(["recipient":recipient,"title":"Position","subject":subject,"message":message,"date":todaysDate,"time":currentTime,"isRead":"false"])
        UserDefaults.standard.set(sentBoxData, forKey: "sentData")
        UserDefaults.standard.synchronize()
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
        
        // Instantiate a view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        if (isUsersAdded()) {
            // ANIMATE  TOAST
            UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
                
                self.view.makeToast("Message Sent", duration: 1.1, position: .center)
                
            }, completion: { finished in
                
                self.appendNewMessageToSentBoxData()
                
                //Check if selected me
                let selectedName = "Jennifer Johnson"
                
                // IF typedSubstring contains Selected, ignore
                let typedSubstring = self.addUsersTextField.text! //search
                if typedSubstring.range(of:selectedName) != nil {
                    //print("\(selectedName) already exists!")
                    
                    self.isMe = true

                    self.appendNewMessageToInBoxData()
                }
                
                // Instantiate a view controller from Storyboard and present it
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
                self.present(vc, animated: false, completion: nil)
                
            })
        } else {
            
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
        return SearchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser") as! AddUsersCell
        
        var Data:Dictionary<String,String> = SearchData[indexPath.row]
        
        // Set text from the data model
        cell.userImage.image = UIImage(named: Data["pic"]!)
        cell.userName.text = Data["name"]
        cell.userName?.font = addUsersTextField.font
        cell.userPosition.text = Data["position"]
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //make "name" blue
        //    let attributedName = NSMutableAttributedString(string: Data["name"]!)
        //    let length = Data["name"]?.characters.count
        //    attributedName.addAttributes(blueColor, range: NSRange(location:0,length:length!))
        
        var selectedData:Dictionary<String,String> = SearchData[indexPath.row]
        
        //Check if selected me
        if(selectedData["name"] == "Jennifer Johnson"){
            isMe = true
        }
        
        // Row selected, so set textField to relevant value, hide tableView, endEditing can trigger some other action according to requirements
        if(addUsersTextField.text?.isEmpty == true) {
            
            addUsersTextField.text = selectedData["name"]!
            //SearchData.remove(at: indexPath.row)
            recipientCount = 1
        } else {
            
            // No Remove what has been typed already
            let typedSubstring = addUsersTextField.text! //search
            let selectedName = selectedData["name"]!
            
            // IF typedSubstring contains Selected, ignore
            if typedSubstring.range(of:selectedName) != nil {
                print("\(selectedName) already exists!")
            }
            else //typedSubstring !contains Selected, add Selected and remove anything !recipient
            {
                
                //remove typed substring if less than 1 recipient exists (selectedData)
                if (recipientCount < 1) {
                    //name exists in typed?
                    // Yes keep this name
                    var names: [String] = []
                    var isNameInUserTextField = false
                    
                    for dict in AllData { //thing is pic, name, position
                        guard let name = dict["name"] else { continue }
                        
                        if typedSubstring.range(of:name) != nil {//check if name is in the typedSubstring
                            isNameInUserTextField = true
                            names.append(name)
                        }
                    }
                    //Yes name found
                    let stringNames = names.joined(separator: ", ")
                    if(isNameInUserTextField)
                    {
                        addUsersTextField.text = stringNames  + ", " + selectedData["name"]!
                    }
                    else {//No name so remove typed text
                        addUsersTextField.text = selectedData["name"]! //there is a bug here if 1.type char, 2. select user, 3. type comma, 4. select user this user replaces recipient line
                    }
                }
                else {
                    addUsersTextField.text = addUsersTextField.text!  + ", " + selectedData["name"]!
                }
                recipientCount += 1
            }
        }
            SearchData=AllData
            addUsersTextField.endEditing(true)
            usersTableView.reloadData()
        usersTableView.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
}
