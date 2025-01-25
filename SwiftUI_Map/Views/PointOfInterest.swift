//
//  PointOfInterest.swift
//  SwiftUI_Map
//
//  Created by Elfo on 21/01/2025.
//

import SwiftUI
import MapKit

fileprivate enum PointOfInterest: String, Hashable, Identifiable, CaseIterable {
    case fireStation = "Fire station"
    case hospital = "Hospital"
    case pharmacy = "Pharmacy"
    
    var id: Self { self }
    
    func getImageName() -> String {
        switch self {
        case .fireStation:
            return "fire.extinguisher"
        case .hospital:
            return "cross"
        case .pharmacy:
            return "pills"
        }
    }
    
    static func getPointOfInterest(points: [PointOfInterest]) -> [MKPointOfInterestCategory] {
        var pointsOfInterest: [MKPointOfInterestCategory] = []
        
        for point in points {
            let pointOfInterest: MKPointOfInterestCategory
            
            switch point {
            case .fireStation:
                pointOfInterest = .fireStation
            case .hospital:
                pointOfInterest = .hospital
            case .pharmacy:
                pointOfInterest = .pharmacy
            }
            
            pointsOfInterest.append(pointOfInterest)
        }
        
        return pointsOfInterest
    }
}

struct PointOfInterestView: View {
    
    @State private var pointsOfInterest: [PointOfInterest] = []
    
    var body: some View {
        ZStack {
            Map()
                .mapStyle(.standard(pointsOfInterest: .including(PointOfInterest.getPointOfInterest(points: pointsOfInterest))))
            
            VStack {
                HStack {
                    PointOfInterestPicker(pointsOfInterest: $pointsOfInterest)
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

#Preview {
    PointOfInterestView()
}

struct PointOfInterestPicker: View {
    
    @Binding fileprivate var pointsOfInterest: [PointOfInterest]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(PointOfInterest.allCases.indices, id: \.self) { index in
                let point = PointOfInterest.allCases[index]
                
                HStack {
                    Image(systemName: point.getImageName())
                        .frame(width: 30)
                        .padding(5)
                        .background {
                            Circle()
                                .stroke(lineWidth: 2)
                        }
                    Text(point.rawValue)
                    
                    Spacer()
                    
                    let showCheckmark = pointsOfInterest.contains(point)
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(showCheckmark ? .black : .clear)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    togglePointOfInterest(point)
                }
                
                if index < PointOfInterest.allCases.count - 1 {
                    Divider()
                }
            }
        }
        .fixedSize()
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.thinMaterial)
        }
    }
    
    fileprivate func togglePointOfInterest(_ point: PointOfInterest) {
        if pointsOfInterest.contains(point) {
            pointsOfInterest.removeAll { $0 == point }
        } else {
            pointsOfInterest.append(point)
        }
    }
}
