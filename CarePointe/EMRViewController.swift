//
//  EMRViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/9/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class EMRViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var EMRWebView: UIWebView!
    @IBOutlet weak var patientTitleLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show patient Name in title
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        patientTitleLabel.text = patientName! + "'s Updates"
        
        //add EMR XML to web view
        //let aWebView = UIWebView()
        let myUrl = NSURL(string: "http://carepointe.cloud/capella_data_xml/Encounter_3.xml")
        let urlRequest = NSURLRequest(url: myUrl! as URL)
        EMRWebView.loadRequest(urlRequest as URLRequest)
        
        // Have to allow arbitrary loads
        //http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
        self.view.addSubview(EMRWebView)
        
        //Activity indicator
        addSavingPhotoView()
    }
    
    func addSavingPhotoView() {
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
