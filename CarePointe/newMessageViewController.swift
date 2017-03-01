//
//  newMessageViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/24/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class newMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate {

    
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
    
    //Drop down list 
    //http://www.iosinsight.com/uitextfield-drop-down-list-in-swift/
    // The sample values
    var values = [["Alice Smith","Nurse","Alice.png"],
                  ["Brad Smith MD","Primary Doctor","brad.png"],
                  ["Dr. Quam","Immunologist","user.png"],
                  ["Jennifer Johnson","Case Manager","jennifer.jpg"],
                  ["John Banks MD","Cardiologist","user.png"],
                  ["Tammie Summers","Case Manager","tammie.png"],
                  ]
    
    let cellReuseIdentifier = "cell"
    
    // If user changes text, hide the tableView
    @IBAction func addUsersTextFieldChanged(_ sender: Any) {
        usersTableView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        addUsersTextField.delegate = self
        subjectTextField.delegate = self
        messageBox.delegate = self
        
//        // handle swipe
//        let hideKeyBoard = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
//        view.addGestureRecognizer(hideKeyBoard)
        // Manage tableView visibility via TouchDown in textField
        //addUsersTextField.addTarget(self, action: #selector(addUsersTextFieldActive), for: UIControlEvents.touchDown)
        //subjectTextField.addTarget(self, action: #selector(subjectTextFieldActive), for: UIControlEvents.touchDown)
        
        // Round userImage
        userImage.layer.cornerRadius = 0.5 * userImage.bounds.size.width
        userImage.clipsToBounds = true
        updateToSavedImage(Userimage: userImage)
        sendButton.layer.cornerRadius = 0.5
        attachFilesButton.layer.cornerRadius = 0.5
        
        messageBox.layer.borderWidth = 1.0
        messageBox.layer.borderColor = UIColor.Iron().cgColor
        messageBox.layer.cornerRadius = 5
        
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow),
                           name: .UIKeyboardWillShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide),
                           name: .UIKeyboardWillHide,
                           object: nil)
        
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
//        if (touch.tapCount == 2) {
//            usersTableView.isHidden = !usersTableView.isHidden
//        }
        
    }
    
    // Toggle the tableView visibility when click on textField
//    func addUsersTextFieldActive() {
//            usersTableView.isHidden = !usersTableView.isHidden
//    }
//    func subjectTextFieldActive(){
//        usersTableView.isHidden = true
//    }
    
    //search
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
        }
        usersTableView.reloadData()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) { //Handle the text changes here
            usersTableView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == subjectTextField){
            usersTableView.isHidden = true
        }
        if(textField == addUsersTextField){
            usersTableView.isHidden = false
        }
    }
    func isUsersAdded() -> Bool {
        
        if (addUsersTextField.text?.isEmpty)! {
            return false
        }
            return true
    }
    
//    func handleSwipes(sender:UISwipeGestureRecognizer) {
//        if (sender.direction == .down) {
//            view.endEditing(true)
//        }
//        
//    }
    
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
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in self.addUsersTextField.becomeFirstResponder()})
        
        present(alert, animated: true){}
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

    //
    // MARK: UITextFieldDelegate
    //
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Your app can do something when textField finishes editing
        print("The textField ended editing. Do something based on app requirements.")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //
    // MARK: UITableViewDataSource
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchData.count//values.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser") as! AddUsersCell
        
        var Data:Dictionary<String,String> = SearchData[indexPath.row]
        
        // Set text from the data model
        cell.userImage.image = UIImage(named: Data["pic"]!) //values[indexPath.row][2])
        cell.userName.text = Data["name"]//values[indexPath.row][0]
        cell.userName?.font = addUsersTextField.font
        cell.userPosition.text = Data["position"]//values[indexPath.row][1]
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var Data:Dictionary<String,String> = SearchData[indexPath.row]
        
        // Row selected, so set textField to relevant value, hide tableView
        // endEditing can trigger some other action according to requirements
        if(addUsersTextField.text?.isEmpty)! {
            addUsersTextField.text = Data["name"] //values[indexPath.row][0]
        } else {
            addUsersTextField.text = addUsersTextField.text! + ", " + Data["name"]! //values[indexPath.row][0]
            usersTableView.isHidden = true
            addUsersTextField.endEditing(true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
}
