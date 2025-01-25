//
//  LocationManager.swift
//  SwiftUI_Map
//
//  Created by Elfo on 25/01/2025.
//

import Foundation
import MapKit

class LocationManager: NSObject {
    
    let manager = CLLocationManager()
    var isAuthorized: Bool = false
    
    override init() {
        super.init()
        
        manager.delegate = self
    }
    
    func checkStatus() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            isAuthorized = true
        case .denied:
            isAuthorized = false
        default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkStatus()
    }
    
    /// Called when the system cannot determined the user position.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error: \(error)")
    }
}
