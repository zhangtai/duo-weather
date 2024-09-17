//
//  CityManager.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/16.
//

import SwiftUI
import SwiftData

@MainActor
class CityManager: ObservableObject {
    @Query private var cities: [City]
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addCity(name: String, latitude: Double, longitude: Double) {
        let newCity = City(name: name, latitude: latitude, longitude: longitude)
        modelContext.insert(newCity)
    }

    func deleteCity(_ city: City) {
        modelContext.delete(city)
    }

    func getAllCities() -> [City] {
        return cities
    }

    func preloadCities() {
        let citiesToPreload = [
            ("Guangzhou", 23.1622, 113.2353),
            ("Yilan", 46.3320, 129.5610),
            ("New York", 40.7128, -74.0060),
            ("London", 51.5074, -0.1278),
            ("Tokyo", 35.6762, 139.6503),
            ("Paris", 48.8566, 2.3522),
            ("Sydney", -33.8688, 151.2093)
        ]

        for (name, latitude, longitude) in citiesToPreload {
            addCity(name: name, latitude: latitude, longitude: longitude)
        }
    }
}
