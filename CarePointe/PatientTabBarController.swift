//
//  PatientTabBarController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/31/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientTabBarController: UITabBarController {
    
    //var myOrder = OrderModel()
    
    //Segue Data Model PTVTableViewController -> Referrals.swift -> here -> (patient portal) PTVDetialViewController.swift
    var segueStoryBoardName: String! //"Referrals" for BACK button in patient portal to get back to referrals
    
    var tabBarSeguePatientID: String!
    var tabBarSeguePatientNotes: String!
    var tabBarSeguePatientName: String!
    var tabBarSeguePatientCPID: String!//appointmentID
    var tabBarSeguePatientDate: String!
    var tabBarSegueHourMin: String!
    var tabBarSegueBookMinutes: String!
    var tabBarSegueProviderName: String!
    var tabBarSegueProviderID: String!
    var tabBarSegueEncounterType: String!
    var tabBarSegueEncounterPurpose: String!
    var tabBarSegueLocationType: String!
    var tabBarSegueBookPlace: String!
    var tabBarSegueBookAddress: String!
    var tabBarSeguePreAuth: String!
    var tabBarSegueAttachDoc: String!
    var tabBarSegueStatus: String!
    var tabBarSegueIsUrgent: String!
    
    var segueSelectedIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
print("segueSelectedIndex: \(segueSelectedIndex)")
        // This will select the tab bar item to show; 0 Feed, 1 Case, 2 Patient, 3 Rx and 4 Forms
        if segueSelectedIndex != nil { selectedIndex = segueSelectedIndex } else { selectedIndex = 2 }
        
        // change Tab view controller normal/selected state text color
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(hex: 0xA1DCF8)/*columbia blue*/], for:.normal)
        
        
        //disable last tab bar items
//        if let items = tabBar.items {
//            if items.count > 0 {
//                let itemToDisable = items[items.count - 1]
//                let itemToDisable2 = items[items.count - 2]
//                itemToDisable.isEnabled = false
//                itemToDisable2.isEnabled = false
//            }
//        }
       
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        if let toViewController = segue.destination as? PTVDetailViewController {
//            let s1 = segueStoryBoardName
//            let s2 = segueStoryBoardID
//            if segueStoryBoardName != nil{
//                toViewController.segueStoryBoardName = s1//segueStoryBoardName
//                toViewController.segueStoryBoardID = s2//segueStoryBoardID
//            }
//        }
//
//    }
    

}
