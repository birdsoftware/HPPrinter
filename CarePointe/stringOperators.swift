//
//  stringOperators.swift
//  CarePointe
//
//  Created by Brian Bird on 5/5/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func splitStringToArray(StringIn:String, deliminator:String) -> [String] {
        //deliminator = "," or " "
        return StringIn.components(separatedBy: deliminator)

    }
 
    
}


