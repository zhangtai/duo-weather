//
//  WeatherComparisonViewModel.swift
//  Duo Weather
//
//  Created by zhangt.ai on 2024/9/14.
//

import Foundation
import SwiftData

@MainActor
class WeatherComparisonViewModel: ObservableObject {
    @Published var weatherData: [WeatherData] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let weatherService: WeatherService

    init(weatherService: WeatherService = WeatherService.shared) {
        self.weatherService = weatherService
    }

    func fetchWeatherData(for cities: [City]) async {
        print("Fetching weather data for cities: \(cities.map { $0.name })")

        isLoading = true
        errorMessage = nil
        weatherData.removeAll()

        do {
            for city in cities {
                print("Fetching data for \(city.name)")
                let data = try await weatherService.fetchWeather(for: city.name, latitude: city.latitude, longitude: city.longitude)
                print("Received data for \(city.name)")
                weatherData.append(data)
            }
        } catch {
            print("Error fetching weather data: \(error)")
            errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
