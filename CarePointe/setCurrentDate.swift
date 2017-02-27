//
//  setCurrentDate.swift
//  CarePointe
//
//  Created by Brian Bird on 2/17/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func setCurrentDateInDefaults() {
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "M/dd/yy"
        
        let result = formatter.string(from: date) //"2/14/2017"
        UserDefaults.standard.set(result, forKey: "currentDate")
        UserDefaults.standard.synchronize()
    }
    
}


//let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)

//http://stackoverflow.com/questions/39310729/problems-with-cropping-a-uiimage-in-swift
extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}
