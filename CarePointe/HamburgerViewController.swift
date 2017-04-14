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
        
        updateProfileFromDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let numberScheduledPatients: Int = UserDefaults.standard.integer(forKey: "numberScheduledPatients")
        dashboardCount.text = "\(numberScheduledPatients)" //# of appointments
        let numberNewPatients: Int = UserDefaults.standard.integer(forKey: "numberNewPatients")
        patientsCount.text = "\(numberNewPatients)"
        
        // UPDATE MESSAGES NOT READ COUNT ------------------------------------------
        var inboxCountInt = UserDefaults.standard.integer(forKey: "inboxCount")
        if isKeyPresentInUserDefaults(key: "inBoxData"){
            let inBoxData = UserDefaults.standard.value(forKey: "inBoxData") as! Array<Dictionary<String, String>>
            inboxCountInt = inBoxData.count
        }
        inboxCount.text = String(inboxCountInt)
    }
    
    func updateProfileFromDefaults() {
        
        //if value does not exists don't update placehold text, O.W. display locally saved text
        
        let fName = UserDefaults.standard.object(forKey: "profileName") as? String ?? "-"
        let lName = UserDefaults.standard.object(forKey: "profileLastName") as? String ?? "-"
        userName.text = fName + " " + lName
        
        let title = UserDefaults.standard.object(forKey: "title") as? String ?? "-"
        userTitle.text = title
        
//        if isKeyPresentInUserDefaults(key: "profileName") {
//            
//            fName =  UserDefaults.standard.string(forKey: "profileName")!
//            if isKeyPresentInUserDefaults(key: "profileLastName") {
//                
//                userName.text = fName + " " + UserDefaults.standard.string(forKey: "profileLastName")!
//                
//            } else {
//                
//                userName.text = fName
//            }
//        }

//        if isKeyPresentInUserDefaults(key: "title") {
//            
//            userTitle.text = UserDefaults.standard.string(forKey: "title")!
//        }

        // UPDATE User Photo
        if isKeyPresentInUserDefaults(key: "imageNeedsUpdate") {
            
            if isKeyPresentInUserDefaults(key: "imagePathKey") {
                // 4 --get encoded image saved above to user defaults
                let imagePather = UserDefaults.standard.value(forKey: "imagePathKey")as! String
                // 5 --get UIImage from imagePath
                let dataer = FileManager.default.contents(atPath: imagePather)
                
                if dataer != nil {
                    let imageer = UIImage(data: dataer!)//unexpectedly found nil while unwrapping an Optional value

                    userPhoto.image = imageer
                    // 8 --rotate image by 90 degrees M_PI_2 "if image is taken from camera"
                    let angle =  CGFloat(Double.pi/2)
                    let tr = CGAffineTransform.identity.rotated(by: angle)
                    userPhoto.transform = tr
                } else { print("found nil while unwrapping Image dataer in HamburgerViewController") }
            }
        }
        
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier: "ShowLogInView", sender: self)
    }

    @IBAction func showDashBoardButtonTapped(_ sender: Any) {
        // Instantiate messages view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController //fourButtonView
        self.present(vc, animated: false, completion: nil)
        
        
    }


}
