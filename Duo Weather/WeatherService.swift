//
//  WeatherService.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//

import Foundation

class WeatherService {
    static let shared = WeatherService()
    private init() {}

    func fetchWeather(for city: String, latitude: Double, longitude: Double) async throws -> WeatherData {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_max,temperature_2m_min,precipitation_sum&timezone=auto"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(APIResponse.self, from: data)

        return WeatherData(city: city, latitude: latitude, longitude: longitude, daily: apiResponse.daily)
    }
}

// This struct represents the structure of the API response
private struct APIResponse: Codable {
    let latitude: Double
    let longitude: Double
    let daily: DailyWeather
}
