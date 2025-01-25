//
//  Selection.swift
//  SwiftUI_Map
//
//  Created by Elfo on 24/01/2025.
//

import SwiftUI
import MapKit

struct Selection: View {
    
    @Environment(ApplicationData.self) private var data
    
    @State private var searchText: String = "Pizza"
    @State private var selectedItem: UUID?
    
    var body: some View {
        Map(position: Bindable(data).cameraPos, selection: $selectedItem) {
            ForEach(data.locations) { place in
                Marker(place.name, coordinate: place.location)
            }
        }
        .onMapCameraChange(frequency: .onEnd) {
            data.cameraPos = .region($0.region)
            Task(priority: .background) {
                await data.findPlaces(searchText: searchText)
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: .constant(true)) {
            SearchView(searchText: $searchText)
        }
        .onChange(of: searchText) {
            Task(priority: .background) {
                await data.findPlaces(searchText: searchText)
            }
        }
        .onChange(of: selectedItem) {
            guard let item = data.locations.first(where: { $0.id == selectedItem }) else { return }
            
            print(item.name)
        }
    }
}

struct SelectionMapFeature: View {
    
    @Environment(ApplicationData.self) private var data
    
    @State private var selection: MapSelection<MKMapItem>?
    
    var body: some View {
        Map(position: Bindable(data).cameraPos, selection: $selection) {
        }
        .mapFeatureSelectionAccessory(.automatic)
        .mapFeatureSelectionDisabled { feature in
            // only allow selection for points of interest.
            feature.kind != .pointOfInterest
        }
    }
}

#Preview {
    Selection()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}

#Preview("Map Feature") {
    SelectionMapFeature()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}
