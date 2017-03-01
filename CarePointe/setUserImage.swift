//
//  setUserImage.swift
//  CarePointe
//
//  Created by Brian Bird on 2/27/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    public func updateToSavedImage(Userimage: UIImageView){
        // UPDATE User Photo
        if isKeyPresentInUserDefaults(key: "imageNeedsUpdate") {
            
            if isKeyPresentInUserDefaults(key: "imagePathKey") {
                // 4 --get encoded image saved above to user defaults
                let imagePather = UserDefaults.standard.value(forKey: "imagePathKey")as! String
                // 5 --get UIImage from imagePath
                let dataer = FileManager.default.contents(atPath: imagePather)
                
                if dataer != nil {
                    let imageer = UIImage(data: dataer!)//unexpectedly found nil while unwrapping an Optional value
                    
                    Userimage.image = imageer
                    // 8 --rotate image by 90 degrees M_PI_2 "if image is taken from camera"
                    let angle =  CGFloat(M_PI_2)
                    let tr = CGAffineTransform.identity.rotated(by: angle)
                    Userimage.transform = tr
                } else { print("found nil while unwrapping") }
            }
        }
        
    }

    
}
