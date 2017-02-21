//
//  hexColor.swift
//  CarePointe
//
//  Created by Brian Bird on 1/27/17.
//  Copyright © 2017
//

import Foundation

import UIKit

public extension UIColor {
    
    public convenience init(hex: UInt32) {
        let mask = 0x000000FF
        
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex) & mask
        
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
}

//0xD7D7D7 Iron

//0x4A9FCA Celestial Blue   -Secondary Title Bar
//0xA1DCF8 Columbia Blue    -Third Title Bar
//0x468401 Fern             -Top and bottum Bar
//0x028401 Green            -Buttons

