//
//  CitySelectionView.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//

import SwiftUI

struct City: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
}

struct CitySelectionView: View {
    @Binding var selectedCities: [City]

    let cities = [
        City(name: "Guangzhou", latitude: 23.1622, longitude: 113.2353),
        City(name: "Yilan", latitude: 46.3320, longitude: 129.5610),
        City(name: "New York", latitude: 40.7128, longitude: -74.0060),
        City(name: "London", latitude: 51.5074, longitude: -0.1278),
        City(name: "Tokyo", latitude: 35.6762, longitude: 139.6503),
        City(name: "Sydney", latitude: -33.8688, longitude: 151.2093),
        City(name: "Paris", latitude: 48.8566, longitude: 2.3522)
    ]

    var body: some View {
        List(cities) { city in
            Button(action: {
                if selectedCities.contains(where: { $0.id == city.id }) {
                    selectedCities.removeAll { $0.id == city.id }
                } else {
                    selectedCities.append(city)
                }
            }) {
                HStack {
                    Text(city.name)
                    Spacer()
                    if selectedCities.contains(where: { $0.id == city.id }) {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .navigationTitle("Select Cities")
    }
}
