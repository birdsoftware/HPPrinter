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
 
//    func stringByAddingPercentEncodingForRFC3986() -> String? {
//        //let unreserved = "-._~/?"
//        //let allowed = NSMutableCharacterSet.alphanumeric()
//        //allowed.addCharacters(in: unreserved)
//        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
//    }
    
}


