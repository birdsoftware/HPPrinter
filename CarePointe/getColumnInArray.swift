//
//  getColumnInArray.swift
//  CarePointe
//
//  Created by Brian Bird on 2/23/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation
//import UIKit

extension Array where Element : Collection {
    func getColumn(column : Element.Index) -> [ Element.Iterator.Element ] {
        return self.map { $0[ column ] }
    }
}
