//
//  WeatherComparisonViewModel.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//

import Foundation

@MainActor
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
            var newWeatherData: [WeatherData] = []
            for city in cities {
                print("Fetching data for \(city.name)")
                let data = try await WeatherService.shared.fetchWeather(for: city.name, latitude: city.latitude, longitude: city.longitude)
                print("Received data for \(city.name)")
                newWeatherData.append(data)
            }
            // Update weatherData on the main thread
            await MainActor.run {
                self.weatherData = newWeatherData
            }
        } catch {
            print("Error fetching weather data: \(error)")
            await MainActor.run {
                self.errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
            }
        }

        await MainActor.run {
            self.isLoading = false
        }
    }
}
