//
//  AppDelegate.swift
//  CarePointe
//
//  Created by Brian Bird  on 12/12/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//

import UIKit
import UXCam //pod 'UXCam'


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UXCam.start(withKey: "614efd0f4112eb5") //bbirdunlv ako //9eb3d8b656c7d44
        
        //check if we have internet connection
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
            if Reachability.isReturningUser() == true { //is returning user
                
                //REQUEST API ENDPOINT KEY and Data
                DispatchREST().beginRestCalls()
                
            }
        } else {
            print("Internet Connection not Available!")
        }
        

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.synchronize()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.synchronize()
    }

}

extension UIColor {
    static func candyGreen() -> UIColor {
        return UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    }
    static func Iron() -> UIColor {
        return UIColor(hex:0xD7D7D7)
    }
    static func celestialBlue() -> UIColor {//-Secondary Title Bar
        return UIColor(hex:0x4A9FCA)
    }
    static func columbiaBlue() -> UIColor {//-Third Title Bar
        return UIColor(hex:0xA1DCF8)
    }
    static func Fern() -> UIColor {//-Top and bottum Bar
        return UIColor(hex:0x468401)
    }
    static func Green() -> UIColor {//-Buttons
        return UIColor(hex:0x028401)
    }
    static func peachCream() -> UIColor {
        return UIColor(hex:0xFFF2DD)
    }
    static func seaBuckthorn() -> UIColor {
        return UIColor(hex:0xFCAB29)
    }
    static func polar() -> UIColor {
        return UIColor(hex:0xE8F8F8)
    }
    static func bostonBlue() -> UIColor {//send message button
        return UIColor(hex:0x3B8DBD)
    }
}




