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
    
    //Segue Data Model from Referrals.swift to PTVDetialViewController.swift
    var segueStoryBoardName: String! //Main?
    //var segueStoryBoardID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("<<<<PTVDetailViewController segueStoryBoardName: \(segueStoryBoardName)")
        
        //let barViewControllers = self.tabBarController?.viewControllers
        //let vc = barViewControllers![2] as! PTVDetailViewController
        //vc.segueStoryBoardName = segueStoryBoardName //shared model

        // This will select the 3rd tab bar item to show the patient item
        selectedIndex = 2
        
        // change Tab view controller normal/selected state text color
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(hex: 0xA1DCF8)/*columbia blue*/], for:.normal)
        
        
        //disable last tab bar items
        if let items = tabBar.items {
            if items.count > 0 {
                let itemToDisable = items[items.count - 1]
                let itemToDisable2 = items[items.count - 2]
                itemToDisable.isEnabled = false
                itemToDisable2.isEnabled = false
            }
        }
       
        
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
