//
//  SingleEMRViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/23/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class SingleEMRViewController: UIViewController, UIWebViewDelegate {
    //http://www.vladmarton.com/parse-xml-document-from-url-to-custom-objects-in-swift/
    
    @IBOutlet weak var EMRWebView: UIWebView!
    @IBOutlet weak var patientTitleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    /*<notes>
    <Modules>
    <Human Human_ID="8"/>
    <EncounterList>
    <Encounter Human_ID="8" Patient_Account_External="8" Encounter_ID="2" Facility_Name="HOME VISIT" Date_of_Service="2017-06-24 11:15:39" Encounter_Provider_ID="2" Encounter_Provider_Signed_Date="0001-01-01 12:00:00" Is_Encounter_Signed_OFF="N" Provider_Name="PHY_1   " View_Summary="Encounter_2.xml" Edit_Capella_Carepointe_URL="https://carepointe.capellaehr.com/New_Login.html?EncounterID=2&amp;HumanID=8&amp;UserName=Phy_1&amp;Pwd=YWN1cnVz&amp;FacName=HOME VISIT"/>
*/

    //segue data
    var segueViewSummary:String!
    var segueEncounterID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show patient Name in title
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        patientTitleLabel.text = patientName! + "'s Encounter \(segueEncounterID!)"
        
//        let demographics = UserDefaults.standard.object(forKey: "demographics") as? [[String]] ?? [[String]]()//saved from PatientListVC
//        let patientID = demographics[0][1]//"UniqueID" 8
        
        //add EMR XML to web view
        //let aWebView = UIWebView()
        print("\(segueViewSummary!)")
        let myUrl = NSURL(string: "http://carepointe.cloud/EHR_XML_Carepointe/\(segueViewSummary!)") //capella_data_xml/Encounter_3.xml")

        
        let urlRequest = NSURLRequest(url: myUrl! as URL)
        EMRWebView.loadRequest(urlRequest as URLRequest)
        
        // Have to allow arbitrary loads
        //http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
        self.view.addSubview(EMRWebView)
        
        //Activity indicator
        addActivityIndicator()
    }
    
    
    func addActivityIndicator() {
        // You only need to adjust this frame to move it anywhere you want
        //activityIndicatorView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        activityIndicatorView.backgroundColor = UIColor.white
        activityIndicatorView.alpha = 0.8
        activityIndicatorView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 210, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = "Getting EMR report ready..."
        
        activityIndicatorView.addSubview(activityView)
        activityIndicatorView.addSubview(textLabel)
        
        view.addSubview(activityIndicatorView)
        //activityIndicatorView.removeFromSuperview()
        
        EMRWebView.delegate = self
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //web activity indicator: http://stackoverflow.com/questions/38390352/how-to-detect-when-a-uiwebview-has-completely-finished-loading-in-swift
        if webView.isLoading {
            // still loading
            return
        }
        
        print("finished")
        // finish and do something here
        activityIndicatorView.removeFromSuperview()
    }
    
    //button actions
    @IBAction func backButtonAction(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "PatientTabBar") as UIViewController
//        self.present(vc, animated: false, completion: nil)
        
        self.performSegue(withIdentifier: "fromEMRtoPatientTabBar", sender: self)
    }
    
    //
    // MARK: - Navigation
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let pvc = segue.destination as? PatientTabBarController {
            
            pvc.segueSelectedIndex = 0 //0 Feed, 1 Case, 2 Patient, 3 Rx and 4 Forms
            
        }
        
    }
    
}
