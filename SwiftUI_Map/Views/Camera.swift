//
//  Camera.swift
//  SwiftUI_Map
//
//  Created by Elfo on 22/01/2025.
//
// The camera is the area of the map that the user sees.

import SwiftUI
import MapKit

struct Camera: View {
    
    @Environment(ApplicationData.self) private var data
    
    var body: some View {
        Map(position: Bindable(data).cameraPos)
            .safeAreaInset(edge: .bottom) {
                VStack {
                    let region = data.cameraPos.region
                    Text("Latitude: \(getLatitudeOrLongitude(degrees: region?.center.latitude))")
                    Text("Longitude: \(getLatitudeOrLongitude(degrees: region?.center.longitude))")
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                .background(.thinMaterial)
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                data.cameraPos = .region(context.region)
            }
    }
    
    func getLatitudeOrLongitude(degrees: CLLocationDegrees?) -> String {
        let result: String
        if let degrees {
            result = "\(degrees.formatted(.number.precision(.fractionLength(3))))"
        } else {
            result = ""
        }
        return result
    }
}

struct CameraWithBoundsAndInteractionModes: View {
    
    @Environment(ApplicationData.self) private var data
    
    var body: some View {
        Map(position: Bindable(data).cameraPos, bounds: data.cameraBounds, interactionModes: .zoom)
    }
}

#Preview {
    Camera()
        .environment(ApplicationData(coordinates: .applePark))
}

#Preview("With bounds and interaction modes") {
    CameraWithBoundsAndInteractionModes()
        .environment(ApplicationData(coordinates: .applePark))
}
