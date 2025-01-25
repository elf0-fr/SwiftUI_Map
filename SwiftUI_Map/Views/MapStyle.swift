//
//  MapStyle.swift
//  SwiftUI_Map
//
//  Created by Elfo on 21/01/2025.
//

import SwiftUI
import MapKit

fileprivate enum Style: String, Hashable, Identifiable, CaseIterable {
    case standard
    case hybrid
    case imagery
    
    var id: Self { self }
    
    func getMapStyle() -> MapStyle {
        switch self {
        case .standard:
            return .standard
        case .hybrid:
            return .hybrid
        case .imagery:
            return .imagery
        }
    }
    
    func getMapStyle(showTraffic: Bool) -> MapStyle {
        switch self {
        case .standard:
            return .standard(showsTraffic: showTraffic)
        case .hybrid:
            return .hybrid(showsTraffic: showTraffic)
        case .imagery:
            return .imagery
        }
    }
}

struct StylePicker: View {
    
    @Binding fileprivate var style: Style
    
    var body: some View {
        Picker("Map style", selection: $style) {
            ForEach(Style.allCases) { style in
                Text(style.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.thinMaterial)
                .shadow(radius: 5)
        }
        .padding()
    }
}

struct MapStyleView: View {
    
    @State private var style: Style = .standard
    
    var body: some View {
        ZStack {
            Map()
                .mapStyle(style.getMapStyle())
            
            VStack {
                StylePicker(style: $style)
                
                Spacer()
            }
        }
    }
}

struct MapStyleViewWithInfo: View {
    
    @State private var style: Style = .standard
    @State private var showsTraffic: Bool = true
    
    var body: some View {
        ZStack {
            Map()
                .mapStyle(style.getMapStyle(showTraffic: showsTraffic))
            
            VStack {
                StylePicker(style: $style)
                
                HStack {
                    Spacer()
                    
                    Toggle(isOn: $showsTraffic) {
                        Image(systemName: "car")
                            .padding(5)
                    }
                    .toggleStyle(.button)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.thinMaterial)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    MapStyleView()
}

#Preview("Traffic") {
    MapStyleViewWithInfo()
}
