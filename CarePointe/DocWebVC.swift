//
//  DocWebVC.swift
//  CarePointe
//
//  Created by Brian Bird on 5/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class DocWebVC: UIViewController {
    
    //titleLabel
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add doc file to web view
        let myUrl = NSURL(string: "http://carepointe.cloud/episode_document/patient_1848/episode_1821/Monica_170503011511.pdf")
        let urlRequest = NSURLRequest(url: myUrl! as URL)
        webView.loadRequest(urlRequest as URLRequest)
        
        // How to allow arbitrary loads
        //http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
        self.view.addSubview(webView)
    }
    
    //
    // #MARK: - Supporting Functions
    //
    func segueToHomeView(){
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fourButtonView") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    func segueToConnectView(){
        let storyboard = UIStoryboard(name: "communication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "communicationVC") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    func segueToPatientTabBar(){
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientTabBar") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    //
    // #MARK: - Buttons
    //
   
    @IBAction func backButtonTapped(_ sender: Any) {
        segueToPatientTabBar()
    }
    
    
}

