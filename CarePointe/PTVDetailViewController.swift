//
//  PTVDetailViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/31/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

class PTVDetailViewController: UIViewController {

    //segment
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //container views
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var containerView2: UIView!
    @IBOutlet weak var containerView3: UIView!
    @IBOutlet weak var containerView4: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonImage: UIImageView!
    
    
    //Segue from PatientTabBarController from Referrals
    var storyBoardName: String!
    var referralsData = [String: String]()
    
    var patientName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get directly https://makeapppie.com/2015/02/04/swift-swift-tutorials-passing-data-in-tab-bar-controllers/
        
        let tbvc = self.tabBarController as! PatientTabBarController
        storyBoardName = tbvc.segueStoryBoardName
        referralsData["PatientID"] =    tbvc.tabBarSeguePatientID//"1848"
        referralsData["PatientNotes"] = tbvc.tabBarSeguePatientNotes
        referralsData["PatientName"] =  tbvc.tabBarSeguePatientName
        referralsData["PatientCPID"] =  tbvc.tabBarSeguePatientCPID//"2637"
        referralsData["PatientDate"] =  tbvc.tabBarSeguePatientDate//"4/1/17"
        referralsData["HourMin"] =      tbvc.tabBarSegueHourMin//":30"
        referralsData["BookMinutes"] =  tbvc.tabBarSegueBookMinutes//"60"
        referralsData["ProviderName"] = tbvc.tabBarSegueProviderName//"Admin Admin"
        referralsData["ProviderID"] =   tbvc.tabBarSegueProviderID//"148"
        referralsData["EncounterType"] = tbvc.tabBarSegueEncounterType//"TCM"
        referralsData["EncounterPurpose"] = tbvc.tabBarSegueEncounterPurpose
        referralsData["LocationType"] = tbvc.tabBarSegueLocationType
        referralsData["BookPlace"] = tbvc.tabBarSegueBookPlace
        referralsData["BookAddress"] = tbvc.tabBarSegueBookAddress
        referralsData["PreAuth"] = tbvc.tabBarSeguePreAuth
        referralsData["AttachDoc"] = tbvc.tabBarSegueAttachDoc
        referralsData["SegueStatus"] = tbvc.tabBarSegueStatus//"Pending"
        referralsData["IsUrgent"] = tbvc.tabBarSegueIsUrgent//"N"
        
        backButton.layer.cornerRadius = 5

        containerView1.isHidden = false
        containerView2.isHidden = true
        containerView3.isHidden = true
        containerView4.isHidden = true
        
        // store specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        patientName = UserDefaults.standard.string(forKey: "patientName")!
        
        // Setup segment control font and font size
        let attr = NSDictionary(object: UIFont(name: "Futura", size: 15.0)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        //Upload Form and NTUC API data
        callFormAndNTUCAPIs()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if storyBoardName != nil {
            if storyBoardName! == "Refferal" {
                backButtonImage.image = UIImage(named: "calendar2.png")
            }
        }
    }
    
    //#MARK - Actions
    @IBAction func segmentControlTapped(_ sender: Any) {
        
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            containerView1.isHidden = false
            containerView2.isHidden = true
            containerView3.isHidden = true
            containerView4.isHidden = true
        case 1:
            containerView1.isHidden = true
            containerView2.isHidden = false
            containerView3.isHidden = true
            containerView4.isHidden = true
        case 2:
            containerView1.isHidden = true
            containerView2.isHidden = true
            containerView3.isHidden = false
            containerView4.isHidden = true
        case 3:
            containerView1.isHidden = true
            containerView2.isHidden = true
            containerView3.isHidden = true
            containerView4.isHidden = false
        default:
            break;
        }
        
    }
    
    // #MARK - functions
    
    //
    // #MARK - buttons
    //
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if storyBoardName != nil {
            if storyBoardName! == "Refferal" {
                
                self.performSegue(withIdentifier: "patientToReferral", sender: self)

            }
        
        } else {
        // 4. Present a view controller from a different storyboard
        let storyboard = UIStoryboard(name: "PatientList", bundle: nil)//"PatientList" //Refferal
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientListView") as UIViewController//"PatientListView" //referralVC TODO: fis segue values needed for referal
        //vc.navigationController?.pushViewController(vc, animated: false)
        self.present(vc, animated: false, completion: nil)
        }
       
            
    }
    
    //
    // #MARK: - UNWIND SEGUE
    //
    //https://www.andrewcbancroft.com/2015/12/18/working-with-unwind-segues-programmatically-in-swift/
    @IBAction func unwindToPatientDashboard(segue: UIStoryboardSegue) {}
    
    //
    //#MARK - segue
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "patientToReferral" {
            if let toViewController = segue.destination as? ReferralsVC {
                toViewController.seguePatientID = referralsData["PatientID"]
                toViewController.seguePatientNotes = referralsData["PatientNotes"]
                toViewController.seguePatientName = referralsData["PatientName"]
                toViewController.seguePatientCPID = referralsData["PatientCPID"]//appointmentID
                toViewController.seguePatientDate = referralsData["PatientDate"]
                toViewController.segueHourMin = referralsData["HourMin"]
                toViewController.segueBookMinutes = referralsData["BookMinutes"]
                toViewController.segueProviderName = referralsData["ProviderName"]
                toViewController.segueProviderID = referralsData["ProviderID"]
                toViewController.segueEncounterType = referralsData["EncounterType"]
                toViewController.segueEncounterPurpose = referralsData["EncounterPurpose"]
                toViewController.segueLocationType = referralsData["LocationType"]
                toViewController.segueBookPlace = referralsData["BookPlace"]
                toViewController.segueBookAddress = referralsData["BookAddress"]
                toViewController.seguePreAuth = referralsData["PreAuth"]
                toViewController.segueAttachDoc = referralsData["AttachDoc"]
                toViewController.segueStatus = referralsData["SegueStatus"]
                toViewController.segueIsUrgent = referralsData["IsUrgent"]
            }
        }
    }
}

// MARK: - Private Methods
private extension PTVDetailViewController {
    func callFormAndNTUCAPIs() {
        let downloadToken = DispatchGroup(); downloadToken.enter()
        
        // 0 get token again -----------
        GETToken().signInCarepoint(dispachInstance: downloadToken)
        
        downloadToken.notify(queue: DispatchQueue.main)  {
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            //get demographics from API latest local save
            let demographics = UserDefaults.standard.object(forKey: "demographics")! as? [[String]] ?? [[String]]()//saved from PatientListVC
            let patientID = demographics[0][1]//"UniqueID"
            
            //GET NTUC STRING--------------------
            let caseFlag = DispatchGroup(); caseFlag.enter();
            GETCase().getNTUCString(token: token, patientID: patientID, dispachInstance: caseFlag)
            
            caseFlag.notify(queue: DispatchQueue.main) {
                let ntuc = UserDefaults.standard.ntuc()
                let ntucDict = ntuc[0]
                let activeEpisodeID = ntucDict["Episode_ID"]
                
//                //GET FORM
//                let formFlag = DispatchGroup(); formFlag.enter()
//                GETForm().getFormByEpisode(token: token, episodeID: activeEpisodeID!, dispachInstance: formFlag)
//                formFlag.notify(queue: DispatchQueue.main){
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateForms"), object: nil)
//                }
                
                if (ntuc.isEmpty == false) {
                    
                    let episodeNoteFlag = DispatchGroup(); episodeNoteFlag.enter();
                    
                    //GET NTUC NOTES--------------------
                    GETEpisode().getEpisodeNotes(token: token, episodeID: activeEpisodeID!, dispachInstance: episodeNoteFlag)
                    
                    episodeNoteFlag.notify(queue: DispatchQueue.main) {
                    }
                }
            }
        }
        
    }


}
