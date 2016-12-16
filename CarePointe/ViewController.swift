//
//  ViewController.swift
//  CarePointe
//
//  Created by Brian Bird  on 12/12/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//  https://www.youtube.com/watch?v=a5pzlbBnfYg

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var AddTaskButton: UIButton!
    @IBOutlet weak var pendingReferralsButton: UIButton!
    @IBOutlet weak var scheduledEncountersButton: UIButton!
    @IBOutlet weak var unreadMessagesButton: UIButton!
    @IBOutlet var buttonBorders: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddTaskButton.layer.cornerRadius = 0.5;
        buttonBorders.layer.borderWidth = 1.0
        //scheduledEncountersButton.layer.borderWidth = 1.0
        //unreadMessagesButton.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear( _ animated: Bool) {
        
        
        //check if user is signed in ELSE go to Sign In
        let isUserSignedIn = UserDefaults.standard.bool(forKey: "isUserSignedIn")
        if(!isUserSignedIn)
        {
            self.performSegue(withIdentifier: "ShowLogInView", sender: self)
        }
        
    }
    @IBAction func logOutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier: "ShowLogInView", sender: self)
    }
    
}
