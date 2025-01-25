//
//  Controls.swift
//  SwiftUI_Map
//
//  Created by Elfo on 24/01/2025.
//

import SwiftUI
import MapKit

struct Controls: View {
    
    @Environment(ApplicationData.self) private var data
    
    var body: some View {
        Map(position: Bindable(data).cameraPos)
            .mapControls {
                MapCompass()
                MapScaleView()
                MapPitchToggle()
                
                // To enabled this feature you need to ask user permission.
                // Add Privacy — Location When In Use Usage Description,
                // or Privacy - Location Always and When In Use Usage Description
                // to the info-plist.
                // Add a description explaining the user why your app needs the location.
                MapUserLocationButton()
            }
            .mapControlVisibility(.visible)
    }
}

struct ControlsWithScope: View {
    
    @Namespace var mapScope
    @Environment(ApplicationData.self) private var data
    
    var body: some View {
        Map(position: Bindable(data).cameraPos, scope: mapScope)
            .mapControlVisibility(.hidden)
            .safeAreaInset(edge: .top) {
                HStack {
                    Spacer()
                    
                    MapPitchToggle(scope: mapScope)
                        .padding(5)
                        .background {
                            Circle()
                                .fill(.thinMaterial)
                                .stroke(.blue, lineWidth: 2)
                                .shadow(radius: 3)
                        }
                }
                .padding()
            }
            .mapScope(mapScope)
    }
}

#Preview {
    Controls()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}

#Preview("With scope") {
    ControlsWithScope()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}
