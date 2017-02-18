//
//  LocationManager.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
    var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        
        // Set loc stuff
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func promptUserForPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    // When user makes a selection
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }

    
}
