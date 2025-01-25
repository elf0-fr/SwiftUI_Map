//
//  MapReader.swift
//  SwiftUI_Map
//
//  Created by Elfo on 25/01/2025.
//

import SwiftUI
import MapKit

struct MapReaderView: View {
    
    @Environment(ApplicationData.self) private var data
    
    var body: some View {
        MapReader { proxy in
            Map(position: Bindable(data).cameraPos) {
                ForEach(data.locations) { location in
                    Marker(location.name, coordinate: location.location)
                }
            }
            .onTapGesture { position in
                data.locations.removeAll()
                
                if let coordinate = proxy.convert(position, from: .local) {
                    let place = PlaceMarker(name: "New location", location: coordinate)
                    data.locations.append(place)
                }
            }
        }
    }
}

#Preview {
    MapReaderView()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}
