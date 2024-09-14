//
//  WeatherComparisonViewModel.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//

import Foundation

class WeatherComparisonViewModel: ObservableObject {
    @Published var weatherData: [WeatherData] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchWeatherData(for cities: [City]) async {
        isLoading = true
        errorMessage = nil
        weatherData = []

        do {
            for city in cities {
                let data = try await WeatherService.shared.fetchWeather(for: city.name, latitude: city.latitude, longitude: city.longitude)
                weatherData.append(data)
            }
        } catch {
            errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
