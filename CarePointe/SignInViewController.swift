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

    @IBOutlet weak var signInActivityView: UIView!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var launchTouchIDButton: UIButton!
    @IBOutlet weak var showSignInAgain: UIButton!
    
    var remindMeToUseTouchID: Bool = true //true = show email/passoword fields
    //var isWorkingOffline: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInActivityView.isHidden = true
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(signinAlertToUser),
                                               name: NSNotification.Name(rawValue: "signinAlert"),
                                               object: nil)
        
        registerButton.isHidden = true
        launchTouchIDButton.isHidden = true
        showSignInAgain.isHidden = true
        
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
            //this is a returning user
                signIn.isHidden = true
                email.isHidden = true
                password.isHidden = true
                launchTouchID()
            
        }
        
        let isReturningUser = Reachability.isReturningUser()
        print("is Returning User: \(isReturningUser)")
        
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
    @objc func signinAlertToUser(){
        
//        self.simpleAlert(title:"Server sign in/authnticate failure",
//                         message:"Contact Administrator",
//                         buttonTitle:"OK")
        notifyUser("Server authntication failure",
                   err: "Notify Administrator")
        
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
                                self.showHiddenSignInFields()
                                
                            case LAError.Code.userCancel.rawValue:
                                //self.notifyUser("Please try again",               //commented out so there is not 2 alers 1. TouchID, 2. Please Try Again
                                //                err: error?.localizedDescription)
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
                            self.touchLoginAlert()//self.notifyUser("Authentication Successful", err: "You now have full access")
                         }//end else
                    }//DispatchQueue
            })//device can use touch
            
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
            
            //check if we DON'T have internet connection
            if Reachability.isConnectedToNetwork() == false {
                
                let myAlert2 = UIAlertController(title: "Internet connection not found",
                                                message: "Enable internet connection to receive new updates.",
                                                preferredStyle: .alert)
                myAlert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    //go to dashboard
                    self.dismiss(animated: false, completion: nil)
                    }))
                
                self.present(myAlert2, animated: true){}
                
            } else {
                //go to dashboard
                self.dismiss(animated: false, completion: nil)
            }
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
        displayAlertMessage(userMessage: "Contact CarePointe Support at 480-494-2466")
    }
    
    //http://www.techotopia.com/index.php/Implementing_TouchID_Authentication_in_iOS_8_Apps
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        let userEmail = email.text!
        let userPassword = password.text!
        
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        print("savedUserPassword:\(savedUserPassword)")
        print("savedUserEmail:\(savedUserEmail)")
        
        print("remindMeToUseTouchID: \(remindMeToUseTouchID)")
        print("userEmail: \(userEmail)")
        print("userPassword: \(userPassword)")

        
        if(userEmail.isEmpty || userPassword.isEmpty){
            
            notifyUser("New user Sign In failure", err: "Make sure E-mail and Password fields are not empty")
            return
        }
        

        //1 Check if NEW USER
        if remindMeToUseTouchID == true {
            
            //check if we have internet connection
            if Reachability.isConnectedToNetwork() == true
            {
                //Internet Connection Available
                
                //TRY signin
                let signinNewUser = DispatchGroup()
                signinNewUser.enter()
                
                // SignIn to API -----------
                let postSignIN = POSTSignin()
                postSignIN.signInUser(userEmail: userEmail, userPassword: userPassword, dispachInstance: signinNewUser)
                
                startActivityIndicator()
                
                // API Responded
                signinNewUser.notify(queue: DispatchQueue.main) {
                    
                    self.stopActivityIndicator()
                    
                    let userExists = UserDefaults.standard.bool(forKey: "APISignedInSuccess")
                    
                    if(userExists){//API {"type":"true"} thus user matched server!
                        
                        //Sign In successfull Save userName/Email, Password, and isUserSignedIn
                        print("Sign In successfull Save userName/Email, Password, and isUserSignedIn")
                        
                        UserDefaults.standard.set(userEmail, forKey: "email")
                        UserDefaults.standard.set(userPassword, forKey: "password")
                        UserDefaults.standard.set(true, forKey: "isUserSignedIn")
                        UserDefaults.standard.synchronize()
                        
                        self.askUseTouchID("Sign In", question: "Use TouchID next time?")
                        //close window moved to askUseTouchID() - self.dismiss(animated: false, completion: nil)
                        
                    } else {
                        //Sign in FAILED
                        let errorMessage = UserDefaults.standard.string(forKey: "APISignedInErrorMessage")
                        self.notifyUser("New user Sign In failure", err: errorMessage)
                    }//user
                    
                }//API
            }//reachable internet
            else {
                notifyUser("Internet connection not found", err: "Enable internet so we can setup your account")
            }
            
        } else {
            //1 Is Returning USER
            
                if isUserEmailPasswordMatchingDefaults() {
                    //Sign In successfull
                    UserDefaults.standard.set(true, forKey: "isUserSignedIn")
                    UserDefaults.standard.synchronize()
                    
                    //check if we DON'T have internet connection
                    if Reachability.isConnectedToNetwork() == false
                    {
                        let myAlert = UIAlertController(title: "Internet connection not found",
                                                        message: "New alerts, messages and patient data will not be available in offline mode. Enable internet to get updates.",
                                                        preferredStyle: .alert)
                        
                                    myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                        //close sign in page and show dashboard
                                        self.dismiss(animated: false, completion: nil)
                                    }))
                            
                                    present(myAlert, animated: true){}
                    } else {
                        //Sign in successfull and we have internet connection
                        //close sign in page and show dashboard
                        self.dismiss(animated: false, completion: nil)
                        
                    }
                    
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
        myAlert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in })
        myAlert.addAction(UIAlertAction(title: "Call CarePointe", style: .default, handler: { (action) -> Void in
            self.open(scheme: "tel://4804942466")
        }))

        self.present(myAlert, animated: true){}
    }
    
    func showHiddenSignInFields() {
        launchTouchIDButton.isHidden = false
        signIn.isHidden = false
        email.isHidden = false
        password.isHidden = false
    }
    
    func isUserEmailPasswordMatchingDefaults() -> Bool {
        
        let userEmail = email.text!
        let userPassword = password.text!
        
        //let patientIDData = UserDefaults.standard.object(forKey: "patientID") as? [[String]] ?? [[String]]()
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        if(userEmail == savedUserEmail )//|| userEmail == "test")
        {
            if(userPassword == savedUserPassword )//|| userPassword == "test")
            {
                //Sign In successfull
                return true
                
            } else {
                //passwords don't match try API
                let message = "User password does not match. Try again."
                trySignin(userEmail: userEmail, userPassword: userPassword, failMessage:message)
//                let userExists = UserDefaults.standard.bool(forKey: "APISignedInSuccess")
//                if(userExists == false){
//                    print("passwords don't match userPassword:\(userPassword), savedUserPassword:\(savedUserPassword)")
//                    simpleAlert(title:"Returning user Sign In failure",
//                                message:"User password does not match. Try again.",
//                                buttonTitle:"OK")
//                }
            }
        } else {
            //Username don't match try API
            let message = "User with this Username does not exists. Try again."
            trySignin(userEmail: userEmail, userPassword: userPassword, failMessage:message)
//            let userExists = UserDefaults.standard.bool(forKey: "APISignedInSuccess")
//            if(userExists == false){
//                print("Username don't match userEmail:\(userEmail), savedUserEmail:\(savedUserEmail)")
//                simpleAlert(title:"Returning user Sign In failure",
//                            message:"User with this Username does not exists. Try again.",
//                            buttonTitle:"OK")
//            }
        }

        return false
        
    }
    
    func trySignin(userEmail: String, userPassword: String, failMessage: String){
        
        let signinNewUser = DispatchGroup()
        signinNewUser.enter()
        
        // SignIn to API -----------
        let postSignIN = POSTSignin()
        postSignIN.signInUser(userEmail: userEmail, userPassword: userPassword, dispachInstance: signinNewUser)
        //startActivityIndicator()
        
        // API Responded
        signinNewUser.notify(queue: DispatchQueue.main) {
            
            //self.stopActivityIndicator()
            
            let userExists = UserDefaults.standard.bool(forKey: "APISignedInSuccess")
            
            if(userExists){
                //sign in success - update password and close window
                UserDefaults.standard.set(userEmail, forKey: "email")
                UserDefaults.standard.set(userPassword, forKey: "password")
                UserDefaults.standard.set(true, forKey: "isUserSignedIn")
                UserDefaults.standard.synchronize()
                self.dismiss(animated: false, completion: nil)
            } else {
                
                        self.simpleAlert(title:"Returning user Sign In failure",
                                    message:failMessage,
                                    buttonTitle:"OK")
            }
        }//API
    }

    
    //Supports CALL IBACTION
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
    
    
    //show busy indicator animtation and text
    func startActivityIndicator(){
        
        signInActivityView.isHidden = false
//        backgroundActivityIndicator.isHidden = false
//        
//        activityView.backgroundColor = UIColor.white
//        activityView.alpha = 0.8
//        activityView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activitySpinView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activitySpinView.frame = CGRect(x: 0, y: 200, width: 60, height: 60)
        activitySpinView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 200, width: 250, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = "Connecting..."
        
        signInActivityView.addSubview(activitySpinView)
        signInActivityView.addSubview(textLabel)
        
        view.addSubview(signInActivityView)
        
    }
    
    func stopActivityIndicator(){
        
        signInActivityView.removeFromSuperview()
        signInActivityView.isHidden = true
        
    }

}
