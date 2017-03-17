//
//  setUpUserData.swift
//  CarePointe
//
//  Created by Brian Bird on 3/15/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    
    
    func setUpUserDataInDefaults() {
        //user image.png or .jpg     name   position
        let userData = [["pic":"Alice.png","name":"Alice Smith","position":"Nurse"],
                        ["pic":"brad.png","name":"Brad Smith MD","position":"Primary Doctor"],
                        ["pic":"user.png","name":"Dr. Quam","position":"Immunologist"],
                        ["pic":"jennifer.jpg","name":"Jennifer Johnson","position":"Case Manager"],
                        ["pic":"user.png","name":"John Banks MD","position":"Cardiologist"],
                        ["pic":"tammie.png","name":"Tammie Summers","position":"Case Manager"],
                        ]
        
        UserDefaults.standard.set(userData, forKey: "userData")
        UserDefaults.standard.synchronize()
    }
    
}
