//
//  newMessageViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/24/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class newMessageViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var attachFilesButton: UIButton!
    @IBOutlet weak var messageBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI
        userImage.layer.cornerRadius = 0.5 * userImage.bounds.size.width
        sendButton.layer.cornerRadius = 0.5
        attachFilesButton.layer.cornerRadius = 0.5
        
        //Tap to Dismiss KEYBOARD
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    // This will hide keyboard when click off field or finished editing text field
    func dismissKeyboard(){
        view.endEditing(true)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        
        // Instantiate a view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        
        // ANIMATE "Patient Complete" TOAST then unwind segue back to MAIN dashboard
        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
            
            self.view.makeToast("Message Sent", duration: 1.1, position: .center)
            
        }, completion: { finished in
            
            
            // Instantiate a view controller from Storyboard and present it
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
            self.present(vc, animated: false, completion: nil)
            
        })

       
        
    }
    
}
