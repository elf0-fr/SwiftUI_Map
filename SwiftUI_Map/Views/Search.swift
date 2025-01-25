//
//  Search.swift
//  SwiftUI_Map
//
//  Created by Elfo on 24/01/2025.
//

import SwiftUI
import MapKit

struct Search: View {
    
    @Environment(ApplicationData.self) private var data
    
    @State private var searchText: String = ""
    
    var body: some View {
        Map(position: Bindable(data).cameraPos) {
            ForEach(data.locations) { place in
                Marker(place.name, coordinate: place.location)
            }
        }
        .onMapCameraChange(frequency: .onEnd) {
            data.cameraPos = .region($0.region)
            Task(priority: .background) {
                await findPlaces()
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: .constant(true)) {
            SearchView(searchText: $searchText)
        }
        .onChange(of: searchText) {
            Task(priority: .background) {
                await findPlaces()
            }
        }
    }
    
    func findPlaces() async {
        guard let region = data.cameraPos.region else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        let places = try? await search.start()
        
        guard let places else {
            await MainActor.run {
                data.locations.removeAll()
            }
            return
        }
        
        let items = places.mapItems
        
        await MainActor.run {
            data.locations.removeAll()
            for item in items {
                if let location = item.placemark.location?.coordinate {
                    let place = PlaceMarker(
                        name: item.name ?? "Undefined",
                        location: location
                    )
                    data.locations.append(place)
                }
            }
        }
    }
}

#Preview {
    Search()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}

struct SearchView: View {
    
    @Binding var searchText: String
    
    @State private var height: CGFloat = 0
    
    var body: some View {
        TextField("Search", text: $searchText)
            .textFieldStyle(.roundedBorder)
            .padding([.top, .leading, .trailing])
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            height = proxy.size.height
                        }
                }
            }
            .presentationDetents([.height(height)])
            .presentationBackgroundInteraction(.enabled(upThrough: .height(height)))
            .presentationDragIndicator(.visible)
            .interactiveDismissDisabled()
            .presentationBackground(.thinMaterial)
    }
}
