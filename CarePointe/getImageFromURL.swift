//
//  getImageFromURL.swift
//  CarePointe
//
//  Created by Brian Bird on 5/18/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class getImage {
    
    let profileImageURL = URL(string: "https://carepointe.cloud/images/profiles/5nzBHAlJH7ljdBlRzkiWPSJz4hfn3iQ2X10c2edJWIIjjj19pFOyMBlA1pCZW29o.jpg")!
    
    func returnUIImageFromURL(URL: String) -> UIImage {
        
        
        var returnImage:UIImage!
        
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: profileImageURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        // Do something with your image.
                        returnImage = image
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        return returnImage
    }

}
