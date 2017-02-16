//
//  KeyboardLayoutConstraint.swift
//  CarePointe
//
//  Created by Brian Bird on 12/29/16.
//  Copyright © 2016 Mogul Pro Media. All rights reserved.
//
//  Easiest way that doesn't even require any code:
//
//  Download KeyboardLayoutConstraint.swift and add (drag & drop) the file into your project, if you're not using the Spring animation framework already.
//  In your storyboard, create a bottom constraint for the View or Textfield, select the constraint (double-click it) and in the Identity Inspector, change its class from NSLayoutConstraint to KeyboardLayoutConstraint.
//  Done!
//  The object will auto-move up with the keyboard, in sync.
//
// https://github.com/MengTo/Spring/blob/master/Spring/KeyboardLayoutConstraint.swift
// The MIT License (MIT)
//
// Copyright (c) 2015 James Tang (j@jamztang.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//Used this class in UpdateProfileViewController
/*
 http://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
 Easiest way that doesn't require any code:
 
 1.Download KeyboardLayoutConstraint.swift and add (drag & drop) the file into your project, if you're not using the Spring animation framework already.
 2.In your storyboard, create a bottom constraint for the object/view/textfield, select the constraint (double-click it) and in the Identity Inspector, change its class from NSLayoutConstraint to KeyboardLayoutConstraint.
 Done!
 The object will auto-move up with the keyboard, in sync.
 
 */


import UIKit

public class KeyboardLayoutConstraint: NSLayoutConstraint {
    
    private var offset : CGFloat = 0
    private var keyboardVisibleHeight : CGFloat = 0
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        offset = constant
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardLayoutConstraint.keyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardLayoutConstraint.keyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Notification
    
    func keyboardWillShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue
                keyboardVisibleHeight = frame.size.height
            }
            
            self.updateConstant()
            switch (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber) {
            case let (.some(duration), .some(curve)):
                
                let options = UIViewAnimationOptions(rawValue: curve.uintValue)
                
                UIView.animate(
                    withDuration: TimeInterval(duration.doubleValue),
                    delay: 0,
                    options: options,
                    animations: {
                        UIApplication.shared.keyWindow?.layoutIfNeeded()
                        return
                }, completion: { finished in
                })
            default:
                
                break
            }
            
        }
        
    }
    
    func keyboardWillHideNotification(_ notification: NSNotification) {
        keyboardVisibleHeight = 0
        self.updateConstant()
        
        if let userInfo = notification.userInfo {
            
            switch (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber) {
            case let (.some(duration), .some(curve)):
                
                let options = UIViewAnimationOptions(rawValue: curve.uintValue)
                
                UIView.animate(
                    withDuration: TimeInterval(duration.doubleValue),
                    delay: 0,
                    options: options,
                    animations: {
                        UIApplication.shared.keyWindow?.layoutIfNeeded()
                        return
                }, completion: { finished in
                })
            default:
                break
            }
        }
    }
    
    func updateConstant() {
        self.constant = offset + keyboardVisibleHeight
    }
    
}
