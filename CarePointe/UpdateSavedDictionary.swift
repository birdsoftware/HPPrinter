//
//  UpdateSavedDictionary.swift
//  CarePointe
//
//  Created by Brian Bird on 3/28/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class UpdateSavedDictionary {
    
    let primaryKey = "User_ID"
    
    func updateDictionary(savedDictName: String, newDict: Array<Dictionary<String,String>>) {
    
        if isKeyPresentInUserDefaults(key: savedDictName) {
            
            //If local array of dicts exists? Save from defaults, o.w. create an empty local dictionary array
            let savedDict = UserDefaults.standard.array(forKey: savedDictName) as? Array<Dictionary<String,String>> ?? Array<Dictionary<String,String>>()
            var updateToDateDict = savedDict
            
            //Save all of the dictionaries from the 1st array (savedDict) that aren't in the 2nd array (newDict) //any values differ save new dictionary
            for item in newDict {
                if !arrayContains(array: savedDict, value: item) {
                    updateToDateDict.append(item)
                }
            }
            
            //SAVE updated array of dictionaries to defaults
            UserDefaults.standard.set(updateToDateDict, forKey: savedDictName)
            UserDefaults.standard.synchronize()
        }
        else {
            
            //SAVE, no key exists - first time launching app
            UserDefaults.standard.set(newDict, forKey: savedDictName)
            UserDefaults.standard.synchronize()
            
        }
        
    }
    
    /*
     * Array of Dictionarries contains given?
     *
     */
    private func arrayContains(array:[[String:String]], value:[String:String]) -> Bool {
        for item in array {
            if item == value {
                return true
            }
        }

        return false
    }
    
    /*
     * Check if key already exists in local memory (user defaults)
     *
     */
    private func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
