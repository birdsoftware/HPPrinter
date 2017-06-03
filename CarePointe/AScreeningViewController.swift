//
//  AScreeningViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/10/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class AScreeningViewController: UIViewController {

    @IBOutlet weak var patientNameLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI/UX setup
        
        // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        patientNameLabel.text = patientName! + "'s Forms"
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
