//
//  ApplicationData.swift
//  SwiftUI_Map
//
//  Created by Elfo on 21/01/2025.
//

import SwiftUI
import MapKit

@Observable class ApplicationData {
    var cameraPos: MapCameraPosition
    var cameraBounds: MapCameraBounds
    var locations: [PlaceMarker] = []
    @ObservationIgnored var locationManager = LocationManager()
    
    init(coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        cameraPos = MapCameraPosition.region(region)
        cameraBounds = MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 200, maximumDistance: 3000)
    }
    
    func findPlaces(searchText: String) async {
        guard let region = cameraPos.region else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        let places = try? await search.start()
        
        guard let places else {
            await MainActor.run {
                locations.removeAll()
            }
            return
        }
        
        let items = places.mapItems
        
        await MainActor.run {
            locations.removeAll()
            for item in items {
                if let location = item.placemark.location?.coordinate {
                    let place = PlaceMarker(
                        name: item.name ?? "Undefined",
                        location: location
                    )
                    locations.append(place)
                }
            }
        }
    }
}

extension CLLocationCoordinate2D {
    static let applePark = CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090)
    
    static let appleGrandCentral = CLLocationCoordinate2D(latitude: 40.752733, longitude: -73.976907)
}
