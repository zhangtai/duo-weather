//
//  WeatherComparisonViewModel.swift
//  Duo Weather
//
//  Created by zhangt.ai on 2024/9/14.
//

import Foundation
import CoreData

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
        print("Fetching weather data for cities: \(cities.map { $0.name ?? "Unknown" })")

        isLoading = true
        errorMessage = nil
        weatherData.removeAll()

        do {
            for city in cities {
                guard let name = city.name, let latitude = city.latitude as? Double, let longitude = city.longitude as? Double else {
                    print("Invalid city data")
                    continue
                }

                print("Fetching data for \(name)")
                let data = try await weatherService.fetchWeather(for: name, latitude: latitude, longitude: longitude)
                print("Received data for \(name)")
                weatherData.append(data)
            }
        } catch {
            print("Error fetching weather data: \(error)")
            errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
