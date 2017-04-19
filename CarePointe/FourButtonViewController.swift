//
//  4ButtonViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 4/13/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class FourButtonViewController: UIViewController {

    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var backgroundActivityIndicator: UIView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userTitle: UILabel!
    
    //var numberOfAPIDownoads = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityView.isHidden = true
        backgroundActivityIndicator.isHidden = true
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateProfileFromDefaults()
        
        //1 Signed In?  GO To Sign In View if NOT
        let isUserSignedIn = UserDefaults.standard.bool(forKey: "isUserSignedIn")
        if(!isUserSignedIn)
        {
            self.performSegue(withIdentifier: "ShowLogInView", sender: self)
            //self.performSegue(withIdentifier: "Show4ButtonView", sender: self)
        }
        
        //2 did eSign? go to eSign View if NOT
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
        
        // Load API data if eSign

            
            let userDidESign = UserDefaults.standard.bool(forKey: "didESign")
            
            if(userDidESign)
            {
                if isKeyPresentInUserDefaults(key: "numberOfAPIDownoads") {
                    //let numberOfAPIDownoads = UserDefaults.standard.integer(forKey: "numberOfAPIDownoads")
                } else {
                
                        //Activity indicator
                        activityIndicator()
                        
                        //REQUEST API ENDPOINT KEY and Data
                        beginAPICalls()
                        
                        let numberOfAPIDownoads = 1
                        UserDefaults.standard.set(numberOfAPIDownoads, forKey: "numberOfAPIDownoads")
                    
                }
                
            }


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // supporting functions
    
    func activityIndicator() {
        
        activityView.isHidden = false
        backgroundActivityIndicator.isHidden = false
        
        activityView.backgroundColor = UIColor.white
        activityView.alpha = 0.8
        activityView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activitySpinView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activitySpinView.frame = CGRect(x: 0, y: 300, width: 60, height: 60)
        activitySpinView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 300, width: 250, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = "Getting your information ready..."
        
        activityView.addSubview(activitySpinView)
        activityView.addSubview(textLabel)
        
        view.addSubview(activityView)
        
    }
    
    func beginAPICalls() {
        
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        let downloadToken = DispatchGroup()
        downloadToken.enter()
        
        let getToken = GETToken()
        getToken.signInCarepoint(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: downloadToken)
        
        let downloadPatients = DispatchGroup()
        downloadPatients.enter()
        
        // 2 patients  -----------
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            //GET Patients
            let token = UserDefaults.standard.string(forKey: "token")
            
            let callGetPatients = GETPatients()
            callGetPatients.getPatients(token: token!, dispachInstance: downloadPatients)
            
        }// -----------------------
        
        
        downloadPatients.notify(queue:DispatchQueue.main){
        
            // finished downloadPatients
            self.activityView.removeFromSuperview()
            self.activityView.isHidden = true
            self.backgroundActivityIndicator.isHidden = true
            
            self.updateProfileFromDefaults()
        }
    }
    
    func updateProfileFromDefaults() {
        
        //if value does not exists don't update placehold text, O.W. display locally saved text
        
        let fName = UserDefaults.standard.object(forKey: "profileName") as? String ?? "-"
        let lName = UserDefaults.standard.object(forKey: "profileLastName") as? String ?? "-"
        userName.text = fName + " " + lName
        
        let title = UserDefaults.standard.object(forKey: "title") as? String ?? "-"
        userTitle.text = title
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
