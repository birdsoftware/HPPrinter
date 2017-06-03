//
//  ReferralsMap.swift
//  CarePointe
//
//  Created by Brian Bird on 5/17/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import MapKit
import UIKit

class ReferralsMap{
    //@IBOutlet weak var mapView: MKMapView!
    
    func showMap(destAddress: String, destName: String) {
        
        //var dest:CLLocationCoordinate2D // = CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059)
        
        let address = destAddress//"1 Infinite Loop, Cupertino, CA 95014"
        
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            
            // Use your location
            self.openMapsAppWithDirections(to: location.coordinate, destinationName: destName)//"Apple HQ")

        }
        
        
        
        //openMapsAppWithDirections(to: dest, destinationName: "some place")

    }

    func mapView(_ MapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped Control: UIControl) {
        
        if Control == annotationView.leftCalloutAccessoryView {
            if let annotation = annotationView.annotation {
                // Unwrap the double-optional annotation.title property or
                // name the destination "Unknown" if the annotation has no title
                let destinationName = (annotation.title ?? nil) ?? "Unknown"
                openMapsAppWithDirections(to: annotation.coordinate, destinationName: destinationName)
            }
        }
        
    }

    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name // Provide the name of the destination in the To: field
        mapItem.openInMaps(launchOptions: options)
    }

}
