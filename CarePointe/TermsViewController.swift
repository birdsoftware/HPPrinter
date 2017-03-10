//
//  TermsViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/13/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var signatureButton: UIButton!
    
    var toggleAgreeButton = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //UI Setup
        agreeButton.layer.cornerRadius = 5
        
    }

    /*Code to get Image and show it on imageView at viewWillAppear() event*/
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //http://stackoverflow.com/questions/29402415/error-when-trying-to-save-image-in-nsuserdefaults-using-swift
        let defaults = UserDefaults.standard
        if let imgData = defaults.object(forKey: "signImage") as? NSData
        {
            if let image = UIImage(data: imgData as Data)
            {
                //fix orentation
                let portraitImage  : UIImage = UIImage(cgImage: image.cgImage! ,
                                                       scale: 1.0 ,
                                                       orientation: .right)
                
                //set image in UIImageView imgSignature
                signatureButton.setImage(portraitImage, for: .normal)
                
                //remove cache after fetching image data
                defaults.removeObject(forKey: "image")
            }
        }
    }
    
    @IBAction func agreeBoxChecked(_ sender: Any) {
            
            // if eSign is TRUE do segue to SignInViewController
            checkIfeSignCompleted()
            
        //}
    }
    
    
    
    func sFunc_imageFixOrientation(img:UIImage) -> UIImage {
        
        
        // No-op if the orientation is already correct
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransform.identity
        
        if (img.imageOrientation == UIImageOrientation.down
            || img.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: img.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        }
        
        if (img.imageOrientation == UIImageOrientation.left
            || img.imageOrientation == UIImageOrientation.leftMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        }
        
        if (img.imageOrientation == UIImageOrientation.right
            || img.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: 0, y: img.size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2));
        }
        
        if (img.imageOrientation == UIImageOrientation.upMirrored
            || img.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if (img.imageOrientation == UIImageOrientation.leftMirrored
            || img.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: img.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContext = CGContext(data: nil, width: Int(img.size.width), height: Int(img.size.height),
                                      bitsPerComponent: img.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: img.cgImage!.colorSpace!,
                                      bitmapInfo: img.cgImage!.bitmapInfo.rawValue)!
        
        ctx.concatenate(transform)
        
        
        if (img.imageOrientation == UIImageOrientation.left
            || img.imageOrientation == UIImageOrientation.leftMirrored
            || img.imageOrientation == UIImageOrientation.right
            || img.imageOrientation == UIImageOrientation.rightMirrored
            ) {
            
            
            ctx.draw(img.cgImage!, in: CGRect(x:0,y:0,width:img.size.height,height:img.size.width))
            
        } else {
            ctx.draw(img.cgImage!, in: CGRect(x:0,y:0,width:img.size.width,height:img.size.height))
        }
        
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)
        
        return imgEnd
    }

    
    func checkIfeSignCompleted(){
        
        if isKeyPresentInUserDefaults(key: "didESign") {
        
            // if eSign complete, perform segue termsCompleted to SignInViewController
            let userDidESign = UserDefaults.standard.bool(forKey: "didESign")
        
            if(userDidESign){
                //agreeButton.setImage(UIImage(named:"checkBox.png"), for: .normal)
                //self.performSegue(withIdentifier: "termsCompleted", sender: self)
                self.dismiss(animated: false, completion: nil)
            } else {
            //show alert
            displayESignNotComplete()
            }
        } else {
            //show alert
            displayESignNotComplete()
        }
        
    }
    
    func displayESignNotComplete() {
        
        
        let myAlert = UIAlertController(title: "eSign Not Complete", message: "Please eSign this document before accepting the terms of the online Business Agreement.", preferredStyle: .alert)
        
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            //Action when OK pressed
            //self.performSegue(withIdentifier: "showDashboard", sender: self)
        }))
        
        
        present(myAlert, animated: true){}
        
    }

    /*
     * Check if value Already Exists in user defaults
     *
     */
//    func isKeyPresentInUserDefaults(key: String) -> Bool {
//        return UserDefaults.standard.object(forKey: key) != nil
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
