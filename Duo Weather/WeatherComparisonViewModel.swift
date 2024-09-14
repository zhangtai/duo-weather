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
        print("Fetching weather data for cities: \(cities)")
        isLoading = true
        errorMessage = nil
        weatherData = []

        do {
            for city in cities {
                print("Fetching data for \(city.name)")
                let data = try await WeatherService.shared.fetchWeather(for: city.name, latitude: city.latitude, longitude: city.longitude)
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
