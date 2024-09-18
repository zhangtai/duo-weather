//
//  MapView.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/17.
//

import SwiftUI
import MapKit

struct MapView: View {
    var cities: [City]
    @State private var cameraPosition: MapCameraPosition

    init(cities: [City]) {
        self.cities = cities

        // Set initial camera position to fit all cities
        let allCoordinates = cities.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let mapRect = MKMapRect.fit(coordinates: allCoordinates)
        _cameraPosition = State(initialValue: .rect(mapRect))
    }

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(cities) { city in
                Annotation(city.name, coordinate: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        Text(city.name)
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(3)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(3)
                    }
                }
            }
        }
        .frame(height: 200)
        .cornerRadius(10)
    }
}

extension MKMapRect {
    static func fit(coordinates: [CLLocationCoordinate2D]) -> MKMapRect {
        let points = coordinates.map { MKMapPoint($0) }
        return points.reduce(MKMapRect.null) { rect, point in
            let pointRect = MKMapRect(origin: point, size: MKMapSize(width: 0, height: 0))
            return rect.union(pointRect)
        }
    }
}
