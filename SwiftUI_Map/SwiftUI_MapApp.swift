//
//  SwiftUI_MapApp.swift
//  SwiftUI_Map
//
//  Created by Elfo on 21/01/2025.
//

import SwiftUI

@main
struct SwiftUI_MapApp: App {
    var body: some Scene {
        WindowGroup {
            Controls()
                .environment(ApplicationData(coordinates: .applePark))
        }
    }
}
