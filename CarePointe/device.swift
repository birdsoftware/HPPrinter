//
//  device.swift
//  CarePointe
//
//  Created by Brian Bird on 12/12/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//

import Foundation

import UIKit
//let modelName = UIDevice.currentDevice().modelName

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"   //320?points
        case "iPod7,1":                                 return "iPod Touch 6"   //320?
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"       //320
        case "iPhone4,1":                               return "iPhone 4s"      //320
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"       //320
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"      //320
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"      //320
        case "iPhone7,2":                               return "iPhone 6"       //375 Screen Width: 375 / Screen Height: 647
        case "iPhone7,1":                               return "iPhone 6 Plus"  //414  iphone 7+ Screen Width: 414 / Screen Height: 736
        case "iPhone8,1":                               return "iPhone 6s"      //375
        case "iPhone8,2":                               return "iPhone 6s Plus" //414
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"         //768
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"         //768
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"         //768
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"       //768
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"     //768 Screen Width: 768 / Screen Height: 1024
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"      //768
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"    //768
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"    //768
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"    //768
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    var modelSize: CGFloat {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return 320.0 //"iPod Touch 5"
        case "iPod7,1":                                 return 320.0 //"iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return 320.0 //"iPhone 4"
        case "iPhone4,1":                               return 320.0 //"iPhone 4s"      //320
        case "iPhone5,1", "iPhone5,2":                  return 320.0 //"iPhone 5"       //320
        case "iPhone5,3", "iPhone5,4":                  return 320.0 //"iPhone 5c"      //320
        case "iPhone6,1", "iPhone6,2":                  return 320.0 //"iPhone 5s"      //320
        case "iPhone7,2":                               return 375.0 //"iPhone 6"       //375
        case "iPhone7,1":                               return 414.0 //"iPhone 6 Plus"  //414
        case "iPhone8,1":                               return 375.0 //"iPhone 6s"      //375
        case "iPhone8,2":                               return 414.0 //"iPhone 6s Plus" //414
        case "iPhone8,4":                               return 375.0 //"iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return 768.0 //"iPad 2"         //768
        case "iPad3,1", "iPad3,2", "iPad3,3":           return 768.0 //"iPad 3"         //768
        case "iPad3,4", "iPad3,5", "iPad3,6":           return 768.0 //"iPad 4"         //768
        case "iPad4,1", "iPad4,2", "iPad4,3":           return 320.0 //"iPad Air"       //768
        case "iPad5,3", "iPad5,4":                      return 320.0 //"iPad Air 2"     //768
        case "iPad2,5", "iPad2,6", "iPad2,7":           return 320.0 //"iPad Mini"      //320
        case "iPad4,4", "iPad4,5", "iPad4,6":           return 320.0 //"iPad Mini 2"    //320
        case "iPad4,7", "iPad4,8", "iPad4,9":           return 320.0 //"iPad Mini 3"    //320
        case "iPad5,1", "iPad5,2":                      return 320.0 //"iPad Mini 4"    //320
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return 768.0 //"iPad Pro"
        case "AppleTV5,3":                              return 768.0 //"Apple TV"
        case "i386", "x86_64":                          return 414.0 //"Simulator"
        default:                                        return 414.0 //identifier
        }
    }
}

// Launch images
// LaunchImage-568h@2x                  640x1136
// LaunchImage-700-568h@2x              640x1136
// LaunchImage-700-Landscape@2x~ipad    2048x1536
// LaunchImage-700-Landscape~ipad       1024x768
// LaunchImage-700-Portrait@2x~ipad     1536x2048
// LaunchImage-700-Portrait~ipad        768x1024
// LaunchImage-700@2x                   640x960
// LaunchImage-800-667h@2x              750x1334
// LaunchImage-800-Landscape-736h@3x    2208x1242
// LaunchImage-800-Portrait-736h@3x     1242x2208
// LaunchImage-Portrait@2x~ipad         1536x2048
// LaunchImage-Portrait~ipad            768x1024
// LaunchImage                          320x480
// LaunchImage@2x                       640x960








