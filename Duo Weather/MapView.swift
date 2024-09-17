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

    @State private var region: MKCoordinateRegion

    init(cities: [City]) {
        self.cities = cities

        // Set initial region to fit all cities
        let allCoordinates = cities.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let minLat = allCoordinates.map { $0.latitude }.min() ?? 0
        let maxLat = allCoordinates.map { $0.latitude }.max() ?? 0
        let minLon = allCoordinates.map { $0.longitude }.min() ?? 0
        let maxLon = allCoordinates.map { $0.longitude }.max() ?? 0

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLon - minLon) * 1.5)

        _region = State(initialValue: MKCoordinateRegion(center: center, span: span))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: cities) { city in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                    Text(city.name)
                        .font(.caption)
                        .foregroundColor(.black)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(3)
                }
            }
        }
        .frame(height: 200)
        .cornerRadius(10)
    }
}
