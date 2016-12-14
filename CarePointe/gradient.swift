//
//  gradient.swift
//  CarePointe
//
//  Created by Brian Bird on 12/13/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//
import UIKit
import Foundation

public extension UIView {
    func applyGradient(colors: [UIColor]) -> Void {
        self.applyGradient(colors: colors, locations: nil)
    }
    
    func applyGradient(colors: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        //gradient.masksToBounds = true
        self.layer.insertSublayer(gradient, at: 0)
    }
}
