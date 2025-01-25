//
//  PlaceMarker.swift
//  SwiftUI_Map
//
//  Created by Elfo on 24/01/2025.
//

import SwiftUI
import MapKit

struct PlaceMarker: Identifiable {
    var id = UUID()
    var name: String
    var location: CLLocationCoordinate2D
}
