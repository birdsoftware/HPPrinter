//
//  DocWebVC.swift
//  CarePointe
//
//  Created by Brian Bird on 5/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class DocWebVC: UIViewController, UIWebViewDelegate {
    
    //titleLabel
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDateFileCreated: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var activityView: UIView!
    
    
    //segue from FilesContainer3VC.swift
    var segueDocumentFullFilePath: String!
    var segueDocumentName: String!
    var segueDocumentCategory: String!
    var segueDocumentCreationDateTime: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleStart = segueDocumentName == "" ? "CarePointe" : segueDocumentName
        let titleEnd = segueDocumentCategory == "" ? "Document View" : segueDocumentCategory
        
        titleLabel.text = titleStart! + " \u{2022} " + titleEnd!
        titleDateFileCreated.text = segueDocumentCreationDateTime
        
        //Add doc file to web view
        let myUrl = NSURL(string: segueDocumentFullFilePath)
        //"http://carepointe.cloud/episode_document/patient_1848/episode_1821/Monica_170503011511.pdf")
        
        let urlRequest = NSURLRequest(url: myUrl! as URL)
        webView.loadRequest(urlRequest as URLRequest)
        
        // How to allow arbitrary loads
        //http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
        self.view.addSubview(webView)
        
        //Activity indicator
        startActivityView()
    }
    
    //
    // #MARK: - Supporting Functions
    //
    func segueToPatientTabBar(){
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientTabBar") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    func startActivityView(){
        activityView.backgroundColor = UIColor.white
        activityView.alpha = 0.8
        activityView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let av = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        av.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        av.startAnimating()
        
        activityView.addSubview(av)
        view.addSubview(activityView)
        webView.delegate = self
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //web activity indicator: http://stackoverflow.com/questions/38390352/how-to-detect-when-a-uiwebview-has-completely-finished-loading-in-swift
        if webView.isLoading {
            // still loading
            activityView.isHidden = false
            return
        }
        
        // finish and do something here
        //activityView.removeFromSuperview()
        activityView.isHidden = true
    }
    
    //
    // #MARK: - Buttons
    //
   
    @IBAction func backButtonTapped(_ sender: Any) {
        segueToPatientTabBar()
    }
    
    
}

