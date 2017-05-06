//
//  PatientTabBarController.swift
//  CarePointe
//
//  Created by Brian Bird on 1/31/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class PatientTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // This will select the 3rd tab bar item to show the patient item
        selectedIndex = 2
        
        // change Tab view controller normal/selected state text color
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(hex: 0xA1DCF8)/*columbia blue*/], for:.normal)
        
        
        //diable last tab bar items
        if let items = tabBar.items {
            if items.count > 0 {
                let itemToDisable = items[items.count - 1]
                let itemToDisable2 = items[items.count - 2]
                itemToDisable.isEnabled = false
                itemToDisable2.isEnabled = false
            }
        }
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
