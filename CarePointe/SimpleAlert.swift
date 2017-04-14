//
//  SimpleAlert.swift
//  CarePointe
//
//  Created by Brian Bird on 4/11/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func simpleAlert(title:String, message:String, buttonTitle:String) {
        
        let myAlert = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        
        myAlert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in })
        present(myAlert, animated: true){}
        
    }
}
