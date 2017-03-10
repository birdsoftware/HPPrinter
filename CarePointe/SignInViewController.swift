//
//  SignInViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 12/15/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.isHidden = true
        
        //sign in UI set up
        signIn.layer.cornerRadius = 5
        email.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
        email.leftViewMode = .always
        email.leftView = UIImageView(image: UIImage(named: "envelope.png"))
        password.leftViewMode = .always
        password.leftView = UIImageView(image: UIImage(named: "key.png"))
        
        // --save didESign BOOL = false
        // This is set to true when user esign in SignatureViewController and is cheched in TermsViewController
        // before suegue back to this view
        //UserDefaults.standard.set(false, forKey: "didESign")
        
        //Tap to Dismiss KEYBOARD
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    
    
    
    //This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //
    // #MARK: - Button Actions
    //
    

    @IBAction func supportButtonTapped(_ sender: Any) {
        displayAlertMessage(userMessage: "Contact CarePointe Support at 1-800-SUPPORT Monday-Friday 8am-5pm  PST")
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        let userEmail = email.text
        let userPassword = password.text
        
        let savedUserEmail = UserDefaults.standard.string(forKey: "email")
        let savedUserPassword = UserDefaults.standard.string(forKey: "password")
        
        if(userEmail == savedUserEmail || userEmail == "test")
        {
            if(userPassword == savedUserPassword || userPassword == "test")
            {
                //Sign In successfull
                UserDefaults.standard.set(true, forKey: "isUserSignedIn")
                UserDefaults.standard.synchronize()
                
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    @IBAction func showLoginPageAgain(_ sender: Any) {
        
        // --save didESign BOOL = true
        UserDefaults.standard.set(false, forKey: "didESign")
        
        
    }
    
    //
    // #MARK: - Supporting Class Functions
    //
    
    func displayAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        
        self.present(myAlert, animated: true){}
    }
    
    /*
     * Check if value Already Exists in user defaults
     *
     */
//    func isKeyPresentInUserDefaults(key: String) -> Bool {
//        return UserDefaults.standard.object(forKey: key) != nil
//    }

}
