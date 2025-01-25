//
//  Marker.swift
//  SwiftUI_Map
//
//  Created by Elfo on 23/01/2025.
//

import SwiftUI
import MapKit

struct MarkerView: View {
    
    @Environment(ApplicationData.self) private var data
    
    var body: some View {
        Map(position: Bindable(data).cameraPos) {
            Marker("Apple Park", coordinate: .applePark)
                .tint(.blue)
        }
    }
}

struct AnnotationView: View {
    
    @Environment(ApplicationData.self) private var data
    
    var body: some View {
        Map(position: Bindable(data).cameraPos) {
            Annotation("Apple Park", coordinate: .applePark) {
                Image(systemName: "apple.logo")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        }
    }
}

struct MapOverlayLevel: View {
    
    @Environment(ApplicationData.self) private var data
    
    var body: some View {
        Map(position: Bindable(data).cameraPos) {
            MapCircle(center: .appleGrandCentral, radius: 100)
                .mapOverlayLevel(level: .aboveLabels)
            MapPolyline(coordinates: [.applePark, .appleGrandCentral])
                .stroke(.red, lineWidth: 5)
        }
    }
}

#Preview("Marker") {
    MarkerView()
        .environment(ApplicationData(coordinates: .applePark))
}

#Preview("Annotation") {
    AnnotationView()
        .environment(ApplicationData(coordinates: .applePark))
}

#Preview("Map overlay level") {
    MapOverlayLevel()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}
