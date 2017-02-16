//
//  PasswordChangeViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/2/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PasswordChangeViewController: UIViewController {
    
    //text
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    //buttons
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    //view
    @IBOutlet weak var whiteBackground: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //UI setup
        accept.layer.cornerRadius = 5
        cancel.layer.cornerRadius = 5
        whiteBackground.layer.cornerRadius = 10
        whiteBackground.layer.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        self.view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        
        /*
         *   Change PLACEHOLDER text color
         *   Select textField in storyboard, In Identity Inspector add color attribute
         *   in User Define Runtime Attributes:
         *   Key Path :  _placeholderLabel.textColor    Type :  Color = Nickel
         *   value :  Your Color or RGB value
         */
        
    }
    
    
    //
    // #MARK: - Supporting Functions
    //
    
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
    
    func savePasswordLocally() {
        
        //✅Store data locally change to mySQL? server later✅
        let defaults = UserDefaults.standard
        defaults.set(password2.text!, forKey: "password")
        defaults.set(true, forKey: "passwordReset")
        
        defaults.synchronize()
        
    }
    
    //
    // #MARK: - Buttons
    //

    @IBAction func acceptButtonTapped(_ sender: Any) {
        
        // check for empty fields
        if((password1.text?.isEmpty)! || (password2.text?.isEmpty)!){
            
            self.displayAlertMessage(userMessage: "Both fields are required.")
        } else if password1.text != password2.text {
            // password are not the same
            self.displayAlertMessage(userMessage: "Passwords do not match.")
        } else {
            // Password Changed Successfully
            //hid this container view from it's superview
            savePasswordLocally()
            self.displayAlertMessage(userMessage: "Password Successfully Changed.")
            
            view.superview?.isHidden = true //removeFromSuperview()
        }
        
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        //hid this container view from it's superview
        view.superview?.isHidden = true
        
    }

}
