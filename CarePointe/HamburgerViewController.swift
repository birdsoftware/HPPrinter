//
//  HamburgerViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/27/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    // Buttons outlets
    @IBOutlet weak var updateProfileButton: UIButton!

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userTitle: UILabel!
    @IBOutlet weak var dashboardCount: UILabel!
    @IBOutlet weak var inboxCount: UILabel!
    @IBOutlet weak var patientsCount: UILabel!
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var countWhiteTop: UIImageView!
    @IBOutlet weak var countWhiteMid: UIImageView!
    @IBOutlet weak var countWhiteBottum: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //  user photo UI set up
            userPhoto.layer.cornerRadius = userPhoto.frame.size.width / 2
            userPhoto.clipsToBounds = true
            userPhoto.layer.borderWidth = 2.0
            userPhoto.layer.borderColor = UIColor.black.cgColor
        // counts white background set up
            countWhiteTop.layer.cornerRadius = 5
            countWhiteMid.layer.cornerRadius = 5
            countWhiteBottum.layer.cornerRadius = 5
        
        // show counts in labels
        //let numberNewPatients = 9
        //let numberScheduledPatients = 4
        //var appPat = [[String]]()
        //if isKeyPresentInUserDefaults(key: "appPat") {
        //    appPat = UserDefaults.standard.object(forKey: "appPat") as! [[String]]
        
        //    let numberNewPatients = (appPat[0].count)
        //    let numberScheduledPatients = (appPat[1].count)
        //}
        
        
        updateProfileFromDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let numberScheduledPatients: Int = UserDefaults.standard.integer(forKey: "numberScheduledPatients")
        dashboardCount.text = "\(numberScheduledPatients)" //# of appointments
        let numberNewPatients: Int = UserDefaults.standard.integer(forKey: "numberNewPatients")
        patientsCount.text = "\(numberNewPatients)"
        
        let inboxNumberMessages = UserDefaults.standard.integer(forKey: "inboxCount")
        inboxCount.text = String(inboxNumberMessages)
    }
    
    /*
     * Check if value Already Exists in user defaults
     *
     */
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func updateProfileFromDefaults() {
        
        //if value does not exists don't update placehold text, O.W. display locally saved text
        var fName: String
        if isKeyPresentInUserDefaults(key: "profileName") {
            
            fName =  UserDefaults.standard.string(forKey: "profileName")!
            if isKeyPresentInUserDefaults(key: "profileLastName") {
                
                userName.text = fName + " " + UserDefaults.standard.string(forKey: "profileLastName")!
                
            } else {
                
                userName.text = fName
            }
        }

        if isKeyPresentInUserDefaults(key: "title") {
            
            userTitle.text = UserDefaults.standard.string(forKey: "title")!
        }

        
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier: "ShowLogInView", sender: self)
    }



}
