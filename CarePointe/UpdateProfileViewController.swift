//
//  UpdateProfileViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/30/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController /*,UITextFieldDelegate*/,UIImagePickerControllerDelegate /*photoLib*/,
    UINavigationControllerDelegate/*photoLib*/ {

    //views
    
    @IBOutlet weak var background1: UIView!
    @IBOutlet weak var background2: UIView!
    @IBOutlet weak var background3: UIView!
    @IBOutlet weak var background4: UIView!
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var containerView2: UIView!
    
    
    //textFields
    @IBOutlet weak var updatePhoto: UIButton!       //This Button Shows the photo
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    // buttons
    @IBOutlet weak var acceptChangesButton: UIButton!
    @IBOutlet weak var cancelChangesButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var addAvailabilityButton: UIButton!

    // Properties
    var imagesDirectoryPath:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up UI
        acceptChangesButton.layer.cornerRadius = 5
        cancelChangesButton.layer.cornerRadius = 5
        resetPasswordButton.layer.cornerRadius = 5
        addAvailabilityButton.layer.cornerRadius = 5
        resetPasswordButton.layer.borderWidth = 2
        addAvailabilityButton.layer.borderWidth = 2
        resetPasswordButton.layer.borderColor = UIColor(hex: 0x028401).cgColor//green
        addAvailabilityButton.layer.borderColor = UIColor(hex: 0x028401).cgColor
        background1.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        background2.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        background4.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        background3.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        containerView1.isHidden = true
        containerView2.isHidden = true
        
       /*
         *   Change PLACEHOLDER text color
         *   Select textField in storyboard, In Identity Inspector add color attribute
         *   in User Define Runtime Attributes: 
         *   Key Path :  _placeholderLabel.textColor    Type :  Color
         *   value :  Your Color or RGB value
         */
        
        /*
          *  GET PLACEHOLDER TEXT FROM API and set in this view
          *  firstNameField.placeholder = "Bob" 
          *  lastNameField.placeholder = "Smith" 
          *  titleField.placeholder = "Care Team Case Manager"
          *  emailField.placeholder = "bob@yahoo.com"
          */
        
        // Display saved defaults to placeholder text fields
        displayLocallySavedTextInPlaceholders()
        
        //✅Store data locally change to mySQL? server later✅
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "passwordReset")
        defaults.synchronize()
        
        //Handle Update Image
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Get the Document directory path
        let documentDirectorPath:String = paths[0]
        // Create a new path for the new images folder
        imagesDirectoryPath = documentDirectorPath + "/ImagePicker"
        var objcBool:ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: imagesDirectoryPath, isDirectory: &objcBool)
        // If the folder with the given path doesn't exist already, create it
        if isExist == false{
            do{
                try FileManager.default.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Something went wrong while creating a new folder")
            }
        }
        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    // This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }


    //
    // #MARK: - Photo Library Button
    //
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        // 2 --Save image to Document directory
        var imagePath = Date().description
        imagePath = imagePath.replacingOccurrences(of: " ", with: "")
        imagePath = imagesDirectoryPath + "/\(imagePath).png"
        let data = UIImagePNGRepresentation(image)
        
        //This line saves the file "data" to path "imagePath" and optionally returns true if operation was successful or file already exists
        let success = FileManager.default.createFile(atPath: imagePath, contents: data, attributes: nil)
        if !success { print("could not create file for image") }
        
        // 3 --store imagePath to user defaults
        //let imagePathText = imagePath
        UserDefaults.standard.setValue(imagePath, forKey: "imagePathKeyTemp")
        UserDefaults.standard.synchronize()
        
        // 4 --get encoded image saved above to user defaults
        let imagePather = UserDefaults.standard.value(forKey: "imagePathKeyTemp")as! String
        
        // 5 --get UIImage from imagePath
        let dataer = FileManager.default.contents(atPath: imagePather)
        let imageer = UIImage(data: dataer!)
        
        //Resize Image newWidth = 200
        //let newImage = resizeImage(image: imageer!, newWidth: 200)
        //let width = (imageer?.size.width)!
        //let height = (imageer?.size.height)!
        //let scale = width! / (imageer?.size.width)!
        //let newHeight = (imageer?.size.height)! * scale
        //let origin = CGPoint(x: (width - width/2)/2, y: (height - height/2)/2 )
        //let size = CGSize(width: width ,height: height)
        //let newImage = imageer?.crop(rect: CGRect(x: 0, y: 0, width: 200, height: 200))
        //let newImage = imageer?.crop(rect: CGRect(origin: origin, size: size))
        
        //fix orientation
        let newImage = imageer?.fixedOrientation()
        
        // 6 --set button image from UIImage
        updatePhoto.setImage(newImage, for: UIControlState.normal)
        
        // 7 --round image corners and add a black outline
        updatePhoto.layer.cornerRadius = updatePhoto.frame.size.width / 2
        updatePhoto.clipsToBounds = true
        updatePhoto.layer.borderWidth = 2.0
        let newColor = UIColor.black
        updatePhoto.layer.borderColor = newColor.cgColor
        
        // 8 --rotate image by 90 degrees M_PI_2 "if image is taken from camera"
        let angle =  CGFloat(M_PI_2)
        let tr = CGAffineTransform.identity.rotated(by: angle)
        updatePhoto.transform = tr
        
        // 9 --crop image to square
        
        
        UserDefaults.standard.set(true, forKey: "newPhotoWasSelected")
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: nil);
    }
    
    //
    // #MARK: - Supporting Functions
    //
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    //
    // #MARK: - Button Actions
    //

    @IBAction func updatePhotoButtonTapped(_ sender: Any) {
        // 1 --Open photo library button, user chooses image
        let imagePicker = UIImagePickerController()
        present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        //displayResetPasswordAlert()
        containerView1.isHidden = false
    }
    
    @IBAction func availabilityButtonTapped(_ sender: Any) {
        containerView2.isHidden = false
    }
    
    func determineWhatTextChanged(profileTextField: UITextField ) -> String {
        let someText = profileTextField.text!
        let someTextIsEmpty = profileTextField.text?.isEmpty
        
        if someTextIsEmpty! {
            return  profileTextField.placeholder!
        } else { return someText }
    }
    
    func saveTextLocally() {
        let fName = determineWhatTextChanged(profileTextField: firstNameField)
        let lName = determineWhatTextChanged(profileTextField: lastNameField)
        let title = determineWhatTextChanged(profileTextField: titleField)
        let email = determineWhatTextChanged(profileTextField: emailField)
        
        //✅Store data locally (user entered or if blank place holder text) change to mySQL? server later✅
        let defaults = UserDefaults.standard
        UserDefaults.standard.set(fName, forKey: "profileName")
        UserDefaults.standard.set(lName, forKey: "profileLastName")
        UserDefaults.standard.set(title, forKey: "title")
        UserDefaults.standard.set(email, forKey: "email")
        
        defaults.synchronize()
        
    }
    
    
    /*
      * Check if value Already Exists in user defaults
      *
      */
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func displayLocallySavedTextInPlaceholders() { //Array<String>
        
//print("\(UserDefaults.standard.string(forKey: "profileName"))")
//print("\(UserDefaults.standard.string(forKey: "profileLastName"))")
//print("\(UserDefaults.standard.string(forKey: "title"))")
//print("\(UserDefaults.standard.string(forKey: "email"))")
        
        //if value does not exists don't update placehold text, O.W. display locally saved text
        if isKeyPresentInUserDefaults(key: "profileName") {
            firstNameField.placeholder =  UserDefaults.standard.string(forKey: "profileName")!
        }
        if isKeyPresentInUserDefaults(key: "profileLastName") {
            lastNameField.placeholder = UserDefaults.standard.string(forKey: "profileLastName")!
        }
        if isKeyPresentInUserDefaults(key: "title") {
            titleField.placeholder = UserDefaults.standard.string(forKey: "title")!
        }
        if isKeyPresentInUserDefaults(key: "email") {
            emailField.placeholder = UserDefaults.standard.string(forKey: "email")!
        }
        
    }
    
    func displayWhatWasChanged() {

        let fName = determineWhatTextChanged(profileTextField: firstNameField)
        let lName = determineWhatTextChanged(profileTextField: lastNameField)
        let title = determineWhatTextChanged(profileTextField: titleField)
        let email = determineWhatTextChanged(profileTextField: emailField)
        let password: String
        let passwordDidChange = UserDefaults.standard.bool(forKey: "passwordReset")
        if passwordDidChange { password = "was updated" }
        else {  password = "did not change" }
       
        
        let changeMessage = "\n\u{2022} First Name: \(fName) \n" + "\n\u{2022} Last Name: \(lName) \n" + "\n\u{2022} Title: \(title) \n" + "\n\u{2022} Email: \(email) \n"
                            + "\n\u{2022} Password \(password) \n"
        
        let myAlert = UIAlertController(title: "Review Your Information", message: changeMessage, preferredStyle: .alert)
        
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            //Action when OK pressed
            self.performSegue(withIdentifier: "showDashboard", sender: self)
        }))
            
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width:40, height:40))
        //        imageView.contentMode = UIViewContentMode.center
        //        imageView.image = UIImage(named: "checked.png")
        //alert.view.addSubview(imageView)
        
        present(myAlert, animated: true){}
        
    }
    
    @IBAction func acceptChangesButtonTapped(_ sender: Any) {
        
        let firstNamePlacementText = firstNameField.placeholder!
        print("\(firstNamePlacementText)")
        
        if isKeyPresentInUserDefaults(key: "newPhotoWasSelected") {
            // 4 --get encoded image saved above to user defaults
            let imagePather = UserDefaults.standard.value(forKey: "imagePathKeyTemp")as! String
            
            UserDefaults.standard.setValue(imagePather, forKey: "imagePathKey")
            UserDefaults.standard.set(true, forKey: "imageNeedsUpdate")
            UserDefaults.standard.synchronize()
        }
        //let wasNewPhotoChosen = UserDefaults.standard.bool(forKey: "newPhotoWasSelected")
        
        //check for new photo
//        if(!wasNewPhotoChosen){
//            
//            displayAlertMessage(userMessage: "Select a new photo")
//            
//            return
//        }
        
        /*
          *   1. Check if text field is empty, 2. display placeholder text for empty fields, 3. update API with fields is not empty
          *
          */
        
        displayWhatWasChanged()
        
        // --save first, last name and title
        
        saveTextLocally()
        
        // --profileNeedsUpdate
        UserDefaults.standard.set(true, forKey: "profileNeedsUpdate")
        UserDefaults.standard.synchronize()
        
        
    }
    
    @IBAction func cancelChangesButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showDashboard", sender: self)
    }
    

}
