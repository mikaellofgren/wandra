//
//  Location.swift
//  Wandra
//
//  Borrowed from
// https://github.com/ehemmete/NetworkView/blob/main/NetworkView/Models/NetworkWorkflow.swift

// Signing and Capabilities - App Sandbox Location is needed for BSSID and Outgoing connections client and import CoreLocation

import Foundation
import CoreLocation
import Network
import SwiftUI

protocol CustomUserLocationDelegate {
    func userLocationUpdated(location: CLLocation)
}
class LocationServices: NSObject, CLLocationManagerDelegate, ObservableObject {
    @State var presentMainAlert = false
    public static let shared = LocationServices()
    var userLocationDelegate: CustomUserLocationDelegate?
    let locationManager = CLLocationManager()
    
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location Changed")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Authorization Changed")
        presentMainAlert = true
    }
    
}

