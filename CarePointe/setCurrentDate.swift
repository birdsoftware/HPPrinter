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
        
        formatter.dateFormat = "M/dd/yyyy"
        
        let result = formatter.string(from: date) //"2/14/2017"
        UserDefaults.standard.set(result, forKey: "currentDate")
        UserDefaults.standard.synchronize()
    }
    
}
