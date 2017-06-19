//
//  Medications.swift
//  CarePointe
//
//  Created by Brian Bird on 6/15/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

fileprivate class BundleTargetingClass {}
func loadJSON<T>(name: String) -> T? {
    guard let filePath = Bundle(for: BundleTargetingClass.self).url(forResource: name, withExtension: "json") else {
        return nil
    }
    
    guard let jsonData = try? Data(contentsOf: filePath, options: .mappedIfSafe) else {
        return nil
    }
    
    guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) else {
        return nil
    }
    
    return json as? T
}
