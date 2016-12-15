//
//  ViewController.swift
//  CarePointe
//
//  Created by Brian Bird  on 12/12/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//

import UIKit

protocol SegueHandlerType {
    // `typealias` has been changed to `associatedtype` for Protocols in Swift 3
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String
{
    
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        
        // still have to use guard stuff here, but at least you're
        // extracting it this time
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier).") }
        
        return segueIdentifier
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    
    let model = UIDevice.current.modelSize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signIn.titleLabel?.textColor = UIColor.white
        
        //self.signIn.applyGradient(colors: [UIColor.blue, UIColor.green])
        //self.view.applyGradient(colors: [UIColor.yellow, UIColor.blue, UIColor.red], locations: [0.0, 0.5, 1.0])
        
        /*
         * Set up Sign In style/graphics for text fields and button
         */
        signIn.layer.cornerRadius = 5
        
        email.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
        
        email.leftViewMode = .always
        email.leftView = UIImageView(image: UIImage(named: "envelope.png"))
        password.leftViewMode = .always
        password.leftView = UIImageView(image: UIImage(named: "key.png"))
        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //TextField change text color on begin edit
    @IBAction func loginInteraction(_ sender: Any) {
        guard let textField = sender as? UITextField else{
            return
        }
        
        let textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        
        switch textField.tag {
        case 1:
            email.textColor = textColor
            break
        case 2:
            password.textColor = textColor
            //Password ***p
            password.isSecureTextEntry = true
            break
        default:
            print("unknown text field tag")
            return
            
        }
        
    }
    
    //show alert if login fields are EMPTY or left with prefilled text
    @IBAction func signInBtn(_ sender: Any) {
        
        let emailLogin = email.text
        //let passwordLogin = password.text
        
        //
        // #MARK: - Save Credentials
        //
        // 😈 save login credentials to NSUserDefaults 😈//
        let defaults = UserDefaults.standard
        defaults.set(emailLogin, forKey: "email")
        //defaults.set(passwordLogin, forKey: "password")
 
        let alert = UIAlertController(title: "Login Problem", message:"Wrong username password.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        
        //IF login fields are empty, then display alert
        if (password.text == "" || email.text == "" || email.text == "E-mail" || password.text == "Password"){
            self.present(alert, animated: true){}
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButton(_ sender: Any) {
        // ✅ this is how I want to write my code! Beautiful!
        performSegue(withIdentifier: .ShowFirstView, sender: self)
    }
    
    //Forgot your details? Button
    @IBAction func forgotDetailsButton(_ sender: Any) {
        let alert = UIAlertController(title: "Forgot your details?", message:"Do you want to change your username or password?.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default) { _ in })
        self.present(alert, animated: true){}
    }
    
    //Support Button
    @IBAction func supportButton(_ sender: Any) {
        let alert = UIAlertController(title: "Need Support?", message:"Place a call with Support?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Call", style: .default) { _ in })
        self.present(alert, animated: true){}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .ShowFirstView:
            // prepare for segue to Foo
            break
        case .ShowSecondView:
            // prepare for segue to Bar
            break
        }
    }
    


}

//We're using a protocl extension here to seperate UIViewController concerns with segue
// Thank you Natasha the Robot for this clean implementation here: https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/
// https://gist.github.com/msewell/5e185518a553b7ba9743451b5b817b31
extension ViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowFirstView
        case ShowSecondView
    }
}

