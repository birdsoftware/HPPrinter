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
    @IBOutlet weak var isConnectedToAPI: UIButton!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userTitle: UILabel!
    
    @IBOutlet weak var alertBadge: UILabel!
    @IBOutlet weak var appointmentBadge: UILabel!
    
    
    
    var errorMessage = ""
    var alertCount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileFromDefaults()

        activityView.isHidden = true
        backgroundActivityIndicator.isHidden = true
        isConnectedToAPI.isHidden = true
        
        let serverSuccess = UserDefaults.standard.bool(forKey: "APISignedInSuccess") 
        if isKeyPresentInUserDefaults(key: "APISignedInErrorMessage") {
            errorMessage = UserDefaults.standard.string(forKey: "APISignedInErrorMessage")!
        }
        if serverSuccess == false {
            isConnectedToAPI.isHidden = false
        }
        if serverSuccess == true {//NOT TESTED - test when API is down move to viewWillAppear!
            isConnectedToAPI.isHidden = true
        }
    
        if isKeyPresentInUserDefaults(key: "RESTGlobalAlerts"){
            let newAlertsCount = UserDefaults.standard.object(forKey: "RESTGlobalAlerts") as? Array<Dictionary<String,String>> ?? []
            alertCount = newAlertsCount.count
        }
        var numberNewPatients = 0
        if isKeyPresentInUserDefaults(key: "RESTAllReferrals"){
            let referrals = UserDefaults.standard.value(forKey: "RESTAllReferrals") as! Array<Dictionary<String,String>>
            
            for referral in referrals {
                switch referral["Status"]! //from tbl_care_plan
                {
                    case "Pending", "Opened":
                    numberNewPatients += 1
                default:
                    break
                }
            }
        }
        createBadgeFrom(UIlabel:alertBadge, text: " \(alertCount) ")
        createBadgeFrom(UIlabel:appointmentBadge, text: " \(numberNewPatients) ")
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(startActivityIndicator),
                                               name: NSNotification.Name(rawValue: "startActivityIndicator"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(stopActivityIndicator),
                                               name: NSNotification.Name(rawValue: "stopActivityIndicator"),
                                               object: nil)
        //Sign In Page - Update profile
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(updateProfile),
                                               name: NSNotification.Name(rawValue: "updateProfile"),
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
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
        
        // Load API data if eSign and false = first time log in/new user
            
            let userDidESign = UserDefaults.standard.bool(forKey: "didESign")
            
            if(userDidESign)
            {
                if isKeyPresentInUserDefaults(key: "numberOfAPIDownoads") {
                    //true not new user

                } else {//false = first time log in/new user
                    
                        //REQUEST API ENDPOINT KEY and Data
                        let beginRest = DispatchREST()
                        beginRest.beginRestCalls()
                        
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
    
    @objc func updateProfile(){
        
        updateProfileFromDefaults()
        
    }
    
    @objc func startActivityIndicator(){
        
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
    
    @objc func stopActivityIndicator(){
     
        self.updateProfileFromDefaults() //make sure most up to date user name and title is shown in this view
        self.updateAlertsCount()
        
        self.activityView.removeFromSuperview()
        self.activityView.isHidden = true
        self.backgroundActivityIndicator.isHidden = true
        
    }
    
    
    //
    // # MARK: Supporting Functions
    //
    
    func open(scheme: String) {
        //http://useyourloaf.com/blog/openurl-deprecated-in-ios10/
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    func updateProfileFromDefaults() {
        
        //if value does not exists don't update placehold text, O.W. display locally saved text
        
        if isKeyPresentInUserDefaults(key: "userProfile") {
        let userProfile = UserDefaults.standard.object(forKey: "userProfile") as? Array<Dictionary<String,String>> ?? []
        
            if userProfile.isEmpty == false {
                let user = userProfile[0]
                let name = user["userName"]!
                let title = user["Title"]!
                let role = user["RoleType"]!
                
                //let fName = UserDefaults.standard.object(forKey: "profileName") as? String ?? "-"
                //let lName = UserDefaults.standard.object(forKey: "profileLastName") as? String ?? "-"
                userName.text = name//fName + " " + lName
                
                //let title = UserDefaults.standard.object(forKey: "title") as? String ?? "-"
                userTitle.text = title + ", " + role
            } else {
                userName.text = "-"
                userTitle.text = "-"
            }
        } else {
            userName.text = "-"
            userTitle.text = "-"
        }
        
        if isKeyPresentInUserDefaults(key: "RESTGlobalAlerts"){
            let newAlertsCount = UserDefaults.standard.object(forKey: "RESTGlobalAlerts") as? Array<Dictionary<String,String>> ?? []
            
            alertCount = newAlertsCount.count
        }
    }
    
    func updateAlertsCount(){
        let newAlertsCount = UserDefaults.standard.object(forKey: "RESTGlobalAlerts") as? Array<Dictionary<String,String>> ?? []
        let newAlertCount = newAlertsCount.count
        alertCount = newAlertCount
    }
    
    func createBadgeFrom(UIlabel:UILabel, text: String) {
        UIlabel.clipsToBounds = true
        UIlabel.layer.cornerRadius = UIlabel.font.pointSize * 1.2 / 2
        UIlabel.backgroundColor = .red//.bostonBlue()
        UIlabel.textColor = .white
        UIlabel.text = text
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

    @IBAction func connectButtonTapped(_ sender: Any) {
        
        // Instantiate messages view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "communication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "communicationVC") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func alertButtonTapped(_ sender: Any) {
        //
        // Instantiate messages view controller from Storyboard and present it
        let storyboard = UIStoryboard(name: "AlertsGlobal", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlertVC") as UIViewController
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func serverStatusButtonTapped(_ sender: Any) {
        
        simpleAlert(title:"API server not responding", message:errorMessage, buttonTitle:"OK")
        
    }
    
    @IBAction func callCarelineButtonTapped(_ sender: Any) {
        
        open(scheme: "tel://4804942466")
        
    }
    //
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
