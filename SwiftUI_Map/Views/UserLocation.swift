//
//  UserLocation.swift
//  SwiftUI_Map
//
//  Created by Elfo on 25/01/2025.
//

import SwiftUI
import MapKit

struct UserLocation: View {
    
    @Environment(ApplicationData.self) private var data
    
    var body: some View {
        Map(position: Bindable(data).cameraPos) {
            if data.locationManager.isAuthorized {
                UserAnnotation()
            }
        }
        .mapControls {
            MapUserLocationButton()
                .disabled(!data.locationManager.isAuthorized)
        }
        .onAppear {
            data.locationManager.manager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: -

import CoreLocationUI

struct UserLocationWithLocationButton: View {
    
    @Environment(ApplicationData.self) private var data
    
    var body: some View {
        Map(position: Bindable(data).cameraPos) {
            if data.locationManager.isAuthorized {
                UserAnnotation()
            }
        }
        .mapControls {
            MapUserLocationButton()
                .disabled(!data.locationManager.isAuthorized)
        }
        .safeAreaInset(edge: .bottom) {
            // Give a one time access to the user location.
            LocationButton(.currentLocation) {
                data.cameraPos = .userLocation(fallback: .automatic)
            }
        }
    }
}

#Preview {
    UserLocation()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}

#Preview("Location Button") {
    UserLocationWithLocationButton()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}
