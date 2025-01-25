//
//  Route.swift
//  SwiftUI_Map
//
//  Created by Elfo on 25/01/2025.
//

import SwiftUI
import MapKit

struct Route: View {
    
    @Environment(ApplicationData.self) private var data
    
    @State private var route: MKRoute?
    
    var body: some View {
        Map(position: Bindable(data).cameraPos) {
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 3)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(alignment: .leading, spacing: 10) {
                Text("From: Apple Grand Central")
                Text("To: Apple Park")
            }
            .font(.headline)
            .padding(25)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThickMaterial)
                    .shadow(radius: 3)
            }
        }
        .onAppear {
            calculateRoute()
        }
    }
    
    func calculateRoute() {
        let coordSource: CLLocationCoordinate2D = .appleGrandCentral
        let placeSource = MKPlacemark(coordinate: coordSource)
        let source = MKMapItem(placemark: placeSource)
        
        let coordDestination: CLLocationCoordinate2D = .applePark
        let placeDestination = MKPlacemark(coordinate: coordDestination)
        let destination = MKMapItem(placemark: placeDestination)
        
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.requestsAlternateRoutes = false
        
        Task {
            let directions = MKDirections(request: request)
            let results = try await directions.calculate()
            let routes = results.routes
            self.route = routes.first
        }
    }
}

#Preview {
    Route()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}
