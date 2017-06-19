//
//  getImageFromURL.swift
//  CarePointe
//
//  Created by Brian Bird on 5/18/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class getImage {
    
    func returnUIImageFromURL(URLString: String, dispachInstance: DispatchGroup) {
        
         let profileImageURL = URL(string: URLString)!//"https://carepointe.cloud/images/profiles/5nzBHAlJH7ljdBlRzkiWPSJz4hfn3iQ2X10c2edJWIIjjj19pFOyMBlA1pCZW29o.jpg")!
        
        //var returnImage:UIImage!
        
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: profileImageURL) { (data, response, error) in
            // The download has finished.
            if (error != nil) {
                print("Error downloading picture:\n\(String(describing: error))")
                dispachInstance.leave() // API Responded
                return
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        // Do something with your image.
                        
                        let success = saveImage(image: image!)//UIImage(named: "profileImage.png")!)
                        
                        dispachInstance.leave() // API Responded
                    } else {
                        print("Couldn't get image: Image is nil")
                        dispachInstance.leave() // API Responded
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    dispachInstance.leave() // API Responded
                }
            }
        }
        downloadPicTask.resume()
        
        //return returnImage
    }

}

func saveImage(image: UIImage) -> Bool {
    guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
        return false
    }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
        return false
    }
    do {
        try data.write(to: directory.appendingPathComponent("profileImage.png")!)
        return true
    } catch {
        print(error.localizedDescription)
        return false
    }
}
