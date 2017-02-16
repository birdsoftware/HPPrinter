//
//  RegisterViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 12/15/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.cornerRadius = 5
        
        userEmail.layer.borderWidth = 1.0
        userPassword.layer.borderWidth = 1.0
        repeatPassword.layer.borderWidth = 1.0
        
        userEmail.leftViewMode = .always
        userEmail.leftView = UIImageView(image: UIImage(named: "envelope.png"))
        userPassword.leftViewMode = .always
        userPassword.leftView = UIImageView(image: UIImage(named: "key.png"))
        repeatPassword.leftViewMode = .always
        repeatPassword.leftView = UIImageView(image: UIImage(named: "key.png"))
        
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
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let uEmail = userEmail.text
        let uPassword = userPassword.text
        let rPassword = repeatPassword.text
        
        //check for empty fields
        if((uEmail?.isEmpty)! || (uPassword?.isEmpty)! || (rPassword?.isEmpty)!)
        {
            //Display alert message
            
            displayAlertMessage(userMessage: "All fields are required")
            
            return
        }
        
        //check if passwords match
        if((uPassword)! != (rPassword)!)
        {
            //Display alert message
            
            displayAlertMessage(userMessage: "Passwords do not match")
            
            return
        }
        
        //✅Store data locally change to mySQL? server later✅
        let defaults = UserDefaults.standard
        defaults.set(userEmail.text, forKey: "email")
        defaults.set(userPassword.text, forKey: "password")
        defaults.synchronize()
        
        //self.dismiss(animated: true, completion: nil)
        
        //Display alert with confirmation
        let myAlert = UIAlertController(title: "Alert", message: "Registration was successful.", preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .default) {
        _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        self.present(myAlert, animated: true){}
    }
    

    func displayAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
    
        self.present(myAlert, animated: true){}
    }
    


}
