//
//  ContentView.swift
//  SwiftUI_Map
//
//  Created by Elfo on 21/01/2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    enum Style: String, Hashable, Identifiable, CaseIterable {
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
    }
    
    @State private var style: Style = .standard
    @State private var isStandard = true
    
    var body: some View {
        ZStack {
            Map()
                .mapStyle(style.getMapStyle())
            
            VStack {
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
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
