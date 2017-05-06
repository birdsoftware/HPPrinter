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
        
        //formatter.dateFormat = "M/dd/yy" //"2/04/2017"
        formatter.dateStyle = .short //"2/4/2017"
        
        let result = formatter.string(from: date)
        UserDefaults.standard.set(result, forKey: "currentDate")
        UserDefaults.standard.synchronize()
    }
    
    func returnCurrentDateOrCurrentTime(timeOnly: Bool) -> String{
        
        let date = Date()
        
        if(timeOnly) {
        
            let formatterTime = DateFormatter()
            formatterTime.timeStyle = .short
            return formatterTime.string(from: date) //4:41 PM
            
        } else {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short //"2/4/2017"
            //formatter.dateFormat = "M/dd/yy" //"2/04/2017"
            return formatter.string(from: date)
            
        }
        
    }
    
    func convertDateStringToDate(longDate: String) -> String{
        
        /* INPUT: longDate = "2017-01-27T05:00:00.000Z"
         * OUTPUT: "1/26/17"
         * date_format_you_want_in_string from
         * http://userguide.icu-project.org/formatparse/datetime
         */
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: longDate)
        
        if date != nil {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            let dateShort = formatter.string(from: date!)
            
            return dateShort
            
        } else {
            
            return longDate
            
        }
    }
    
}



//let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)

////http://stackoverflow.com/questions/39310729/problems-with-cropping-a-uiimage-in-swift
//extension UIImage {
//    func crop( rect: CGRect) -> UIImage {
//        var rect = rect
//        rect.origin.x*=self.scale
//        rect.origin.y*=self.scale
//        rect.size.width*=self.scale
//        rect.size.height*=self.scale
//        
//        let imageRef = self.cgImage!.cropping(to: rect)
//        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
//        return image
//    }
//}
