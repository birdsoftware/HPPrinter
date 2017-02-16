//
//  addCustomBorder.swift
//  CarePointe
//
//  Created by Brian Bird on 1/27/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    //http://stackoverflow.com/questions/32304073/swift-label-only-border-left
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 15, width: thickness, height: self.frame.height*0.7)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 15, width: thickness, height: self.frame.height*0.7)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
