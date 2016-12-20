//
//  ViewController.swift
//  CarePointe
//
//  Created by Brian Bird  on 12/12/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//  https://www.youtube.com/watch?v=a5pzlbBnfYg log in example

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var AddTaskButton: UIButton!
    @IBOutlet weak var pendingReferralsButton: UIButton!
    @IBOutlet weak var scheduledEncountersButton: UIButton!
    @IBOutlet weak var unreadMessagesButton: UIButton!
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var hemburgerViewImage: UIImageView!

    @IBOutlet weak var tasksTableView: UITableView!
    
    @IBOutlet weak var hamburger: UIBarButtonItem!
    
    @IBOutlet weak var leadingConstraintHamburgerView: NSLayoutConstraint!
    
    var hamburgerMenuShowing = false
    
    var times = ["12:32AM","01:56PM","03:22PM","11:12AM","10:52AM","12:01PM","07:02AM","05:05PM","07:25PM","09:43PM"]
    var patients = ["Ruth Quinones", "Barrie Thomson", "Victor Owen", "Bill Summers", "Alice Njavro", "Michael Levi", "Elida Martinez", "John Banks","Brian Bird", "Cindy Lopper"]
    var tasks = ["Careflows update 1", "DISPOSITION Patient profile IDT Update", "Patient profile Update", "Telemed update", "Patient profile Screening update", "Referrals details update", "patient profile update 2", "Patient medication", "Lunch Update", "musical IDT Update"]
    //var photos = [UIImage(named: "patientUpdate.png"), UIImage(named: "disposition.png"), UIImage(named: "patientUpdate.png"), UIImage(named: "telemed.png"), UIImage(named: "screening.png"), UIImage(named: "referral.png"), UIImage(named: "patientUpdate.png"), UIImage(named: "patientUpdate.png")]
    var photos = [UIImage(named: "orange.circle.png"), UIImage(named: "orange.circle.png"), UIImage(named: "gray.circle.png"), UIImage(named: "orange.circle.png"), UIImage(named: "gray.circle.png"), UIImage(named: "gray.circle"), UIImage(named: "orange.circle.png"), UIImage(named: "orange.circle.png"), UIImage(named: "orange.circle.png"), UIImage(named: "orange.circle.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddTaskButton.layer.cornerRadius = 5
        pendingReferralsButton.layer.borderWidth = 1.0
        scheduledEncountersButton.layer.borderWidth = 1.0
        unreadMessagesButton.layer.borderWidth = 1.0
        
        leadingConstraintHamburgerView.constant = -270
        hamburgerView.layer.shadowOpacity = 1
        
        hemburgerViewImage.layer.cornerRadius = hemburgerViewImage.frame.size.width / 2
        hemburgerViewImage.clipsToBounds = true
        hemburgerViewImage.layer.borderWidth = 2.0
        let newColor = UIColor.black
        hemburgerViewImage.layer.borderColor = newColor.cgColor
        //hemburgerViewImage.layer.cornerRadius = 10
        
    }
    
    
    override func viewDidAppear( _ animated: Bool) {
        
        //check if user is signed in ELSE go to Sign In View
        let isUserSignedIn = UserDefaults.standard.bool(forKey: "isUserSignedIn")
        if(!isUserSignedIn)
        {
            self.performSegue(withIdentifier: "ShowLogInView", sender: self)
        }
        
        // change navigation bar to custom color "fern"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0.27, green: 0.52, blue: 0.0, alpha: 1.0)
        
        // change navigation bar button size
        //hamburger.width = 20.0;
        
    }
    
    //
    // #MARK: - Button Actions
    //
    
    @IBAction func AddTaskButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ShowAddTaskView", sender: self)
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier: "ShowLogInView", sender: self)
    }
    
    @IBAction func hamburgerBarButtonTapped(_ sender: Any) {
        
        if(hamburgerMenuShowing) {//if showing hide menu
            leadingConstraintHamburgerView.constant = -270
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else {
            leadingConstraintHamburgerView.constant = 0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        hamburgerMenuShowing = !hamburgerMenuShowing
    }
    
    
    //
    // #MARK: - Table View
    //
    
    //[2] RETURN number of ROWS in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return patients.count
        
    }
    
    //[3] RETURN actual CELL to be displayed
    func tableView(_ tableView: UITableView,
                   cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! TaskCustomCell
        
        cell.photo.image = photos[IndexPath.row]
        cell.task.text = tasks[IndexPath.row]
        cell.patient.text = patients[IndexPath.row]
        cell.time.text = times[IndexPath.row]
        
        return cell
    }
    
}
