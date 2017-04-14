//
//  4ButtonViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 4/13/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class FourButtonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //check if user is signed in ELSE go to Sign In View
        let isUserSignedIn = UserDefaults.standard.bool(forKey: "isUserSignedIn")
        if(!isUserSignedIn)
        {
            self.performSegue(withIdentifier: "ShowLogInView", sender: self)
            //self.performSegue(withIdentifier: "Show4ButtonView", sender: self)
        }
        
        
        if isKeyPresentInUserDefaults(key: "didESign") {

            //check if user did eSign
            let userDidESign = UserDefaults.standard.bool(forKey: "didESign")

            if(!userDidESign)
            {
                self.performSegue(withIdentifier: "showTermsView", sender: self)
            }
        } else { //no eSign defaults key present so show the terms and condtions page
            self.performSegue(withIdentifier: "showTermsView", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //
    // MARK: - Button Actions
    //
    
    
    @IBAction func patientsButtonTapped(_ sender: Any) {
        
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "PatientList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientListView") as UIViewController
        //vc.navigationController?.pushViewController(vc, animated: false)
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func appointmentsButtonTapped(_ sender: Any) {
        
        // Instantiate messages view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavControllerMainDB") as UIViewController //fourButtonView
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func messagesButtonTapped(_ sender: Any) {
        
        // Instantiate messages view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "messages") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        
        // Instantiate messages view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "updateYourProfile") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
