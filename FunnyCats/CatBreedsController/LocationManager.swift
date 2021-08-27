//
//  LocationManager.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 26.08.2021.
//  Copyright © 2021 Oleksandr Solokha. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject {
    
    static func getLocation(forPlaceCalled name: String, completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        
        print("Decode location for \(name)")
        
        geocoder.geocodeAddressString(name) { placemarks, error in
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                
                completion(nil)
                
                return
            }
            
            guard let placemark = placemarks?[0] else { print("*** Error in \(#function): placemark is nil")
                
                completion(nil)
                
                return
            }
            
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                
                completion(nil)
                
                return
            }
            
            completion(location)
        }
    }
}
