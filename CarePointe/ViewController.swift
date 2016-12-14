//
//  ViewController.swift
//  CarePointe
//
//  Created by Brian Bird  on 12/12/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//

import UIKit

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
        
        signIn.layer.cornerRadius = 5
        
        email.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
        
        email.leftViewMode = .always
        email.leftView = UIImageView(image: UIImage(named: "envelope.png"))
        password.leftViewMode = .always
        password.leftView = UIImageView(image: UIImage(named: "key.png"))
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
            break
        default:
            print("unknown text field tag")
            return
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

