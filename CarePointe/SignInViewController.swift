//
//  SignInViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 12/15/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//

import UIKit

import LocalAuthentication

class SignInViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var launchTouchIDButton: UIButton!
    
    var remindMeToUseTouchID: Bool = true //true = show email/passoword fields
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.isHidden = true
        launchTouchIDButton.isHidden = true
        
        //sign in UI set up
        signIn.layer.cornerRadius = 5
        email.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
        email.leftViewMode = .always
        email.leftView = UIImageView(image: UIImage(named: "envelope.png"))
        password.leftViewMode = .always
        password.leftView = UIImageView(image: UIImage(named: "key.png"))
        
        if isKeyPresentInUserDefaults(key:  "remindMeToUseTouchID") {
            remindMeToUseTouchID = UserDefaults.standard.bool(forKey: "remindMeToUseTouchID")
        }
        
        //check if using touchID and hide elements
        if (remindMeToUseTouchID == false) {
            signIn.isHidden = true
            email.isHidden = true
            password.isHidden = true
            launchTouchID()
        }
        
        
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
    
    @IBAction func testTouchIDTapped(_ sender: Any) {
        launchTouchID()
    }
    
    func launchTouchID() {
        
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            // Device can use TouchID
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Access requires authentication",
                reply: {(success, error) in
                    DispatchQueue.main.async {
                        
                        if error != nil {
                            
                            switch error!._code {
                                
                            case LAError.Code.systemCancel.rawValue:
                                self.notifyUser("Session cancelled",
                                                err: error?.localizedDescription)
                                //"Session cancelled" is shown 1st then "Please try again" below is shown 
                                
                            case LAError.Code.userCancel.rawValue:
                                self.notifyUser("Please try again",
                                                err: error?.localizedDescription)
                                self.showHiddenSignInFields()
                                
                            case LAError.Code.userFallback.rawValue:
                                self.notifyUser("Authentication",
                                                err: "Password PIN option selected - No PIN Set Up.")
                                // Custom code to obtain password here
                                self.showHiddenSignInFields()
                                
                            default:
                                self.notifyUser("Authentication failed",
                                                err: error?.localizedDescription)
                                self.showHiddenSignInFields()
                            }
                            
                        } else {
                            //self.notifyUser("Authentication Successful", err: "You now have full access")
                            self.touchLoginAlert()
                        }
                    }
            })
            
        } else {
            // Device cannot use TouchID
            switch error!.code{
                
            case LAError.Code.touchIDNotEnrolled.rawValue:
                notifyUser("TouchID is not enrolled",
                           err: error?.localizedDescription)
                
            case LAError.Code.passcodeNotSet.rawValue:
                notifyUser("A passcode has not been set",
                           err: error?.localizedDescription)
                
            default:
                notifyUser("TouchID not available",
                           err: error?.localizedDescription)
                
            }
        }    
    }
    
    
    func touchLoginAlert(){
        
        let myAlert = UIAlertController(title: "Authentication Successful",
                                        message: "You now have full access",
                                        preferredStyle: .alert)
        
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

            //Sign In successfull
            UserDefaults.standard.set(true, forKey: "isUserSignedIn")
            UserDefaults.standard.synchronize()
            //go to dashboard
            self.dismiss(animated: false, completion: nil)
        }))
        
        present(myAlert, animated: true){}
    }
    
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
                                      message: err,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true,
                     completion: nil)
    }
    
    func askUseTouchID(_ msg: String, question: String?) {
        let alert = UIAlertController(title: msg,
                                      message: question,
                                      preferredStyle: .alert)
        
        let doAction = UIAlertAction(title: "YES",
                                     style: .default, handler: { (action) -> Void in
                                        
                                        //Sign In successfull
                                        self.remindMeToUseTouchID = false
                                        UserDefaults.standard.set(false, forKey: "remindMeToUseTouchID")
                                        UserDefaults.standard.synchronize()
                                        
                                        //go to dashboard
                                        self.dismiss(animated: false, completion: nil)
        })
        
        
        let remindAction = UIAlertAction(title: "NO Remind me next time",
                                         style: .cancel, handler: { (action) -> Void in
                                            
                                            //Sign In successfull
                                            self.remindMeToUseTouchID = true
                                            //go to dashboard
                                            self.dismiss(animated: false, completion: nil)
        })
        
        alert.addAction(doAction)
        alert.addAction(remindAction)
        
        self.present(alert, animated: true,
                     completion: nil)
    }
//---------------- END TouchID ---------------------------

    @IBAction func supportButtonTapped(_ sender: Any) {
        displayAlertMessage(userMessage: "Contact CarePointe Support at 1-800-SUPPORT Monday-Friday 8am-5pm  PST")
    }
    
    //http://www.techotopia.com/index.php/Implementing_TouchID_Authentication_in_iOS_8_Apps
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
                
                //Use touchID next time? YES | NO remind me next time
                askUseTouchID("Sign In", question: "Use TouchID next time?")
                
                //close window moved to askUseTouchID()
                //self.dismiss(animated: false, completion: nil)
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
    
    func showHiddenSignInFields() {
        launchTouchIDButton.isHidden = false
        signIn.isHidden = false
        email.isHidden = false
        password.isHidden = false
    }

}
