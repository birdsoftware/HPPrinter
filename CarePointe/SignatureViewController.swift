//
//  SignatureViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/13/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController, YPSignatureDelegate {
    
    @IBOutlet weak var submitSignatureButton: UIButton!
    @IBOutlet weak var clearSignatureButton: UIButton!
    
    //In storyboard Inspector set a view's custom class to YPDrawSignatureView.swift
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    
    
    //var signImage: UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeLeft.rawValue), forKey: "orientation")
        
        // UI/UX
        submitSignatureButton.layer.cornerRadius = 5
        clearSignatureButton.layer.cornerRadius = 5
        submitSignatureButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        clearSignatureButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        submitSignatureButton.isHidden = true
        
        
        // delegation
        signatureView.delegate = self
    }
    
    //
    // #MARK: - Button Actions
    //
    
    @IBAction func clearSignatureButtonTapped(_ sender: Any) {
        self.signatureView.clear()
    }
    
    
    @IBAction func submitSignatureButtonTapped(_ sender: Any) {
        
        // --save didESign BOOL = true
        UserDefaults.standard.set(true, forKey: "didESign")
        
        let signImage = self.signatureView.getCroppedSignature(scale:1)!
        
        let imgData = UIImageJPEGRepresentation(signImage, 1)
        UserDefaults.standard.set(imgData, forKey: "signImage")
        
        self.performSegue(withIdentifier: "finishSigning", sender: self)//leaving for TermsViewController
    }
    

    // The delegate methods gives feedback to the instanciating class
    func finishedDrawing() {
        submitSignatureButton.isHidden = false
    }
    
    func startedDrawing() {
        print("Started")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
