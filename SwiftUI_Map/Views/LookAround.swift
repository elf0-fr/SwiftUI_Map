//
//  LookAround.swift
//  SwiftUI_Map
//
//  Created by Elfo on 25/01/2025.
//

import SwiftUI
import MapKit

struct LookAround: View {
    
    @Environment(ApplicationData.self) private var data
    
    @State private var openLookAroundPreview = false
    @State private var lookAroundScene: MKLookAroundScene?
    
    var body: some View {
        Map(position: Bindable(data).cameraPos)
            .overlay(alignment: .top) {
                if openLookAroundPreview {
                    LookAroundPreview(initialScene: lookAroundScene)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .overlay(alignment: .bottomTrailing) {
                            Button("Hide Look Around View") {
                                openLookAroundPreview = false
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.trailing, 5)
                        }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !openLookAroundPreview  {
                    Button("Show Look Around View", action: showStreetView)
                        .buttonStyle(.borderedProminent)
                }
            }
    }
    
    func showStreetView() {
        guard let region = data.cameraPos.region else { return }
        
        Task {
            let request = MKLookAroundSceneRequest(coordinate: region.center)
            if let scene = try? await request.scene {
                lookAroundScene = scene
                openLookAroundPreview = true
            }
        }
    }
}

struct LookAroundViewer: View {
    
    @Environment(ApplicationData.self) private var data
    
    @State private var openLookAroundViewer = false
    @State private var lookAroundScene: MKLookAroundScene?
    
    var body: some View {
        Map(position: Bindable(data).cameraPos)
            .safeAreaInset(edge: .bottom) {
                Button("Show Look Around View", action: showStreetView)
                    .buttonStyle(.borderedProminent)
            }
            .lookAroundViewer(
                isPresented: $openLookAroundViewer,
                initialScene: lookAroundScene
            )
    }
    
    func showStreetView() {
        guard let region = data.cameraPos.region else { return }
        
        Task {
            let request = MKLookAroundSceneRequest(coordinate: region.center)
            if let scene = try? await request.scene {
                lookAroundScene = scene
                openLookAroundViewer = true
            }
        }
    }
}

#Preview {
    LookAround()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}

#Preview("Viewer Modifier") {
    LookAroundViewer()
        .environment(ApplicationData(coordinates: .appleGrandCentral))
}
