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

        print("Fetching data from URL: \(urlString)")
        let (data, _) = try await URLSession.shared.data(from: url)
        print("Received data from API")
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(APIResponse.self, from: data)
        print("Decoded API response")

        return WeatherData(city: city, latitude: latitude, longitude: longitude, daily: apiResponse.daily)
    }

    // Add this test function
    func testFetch() async {
        do {
            let testData = try await fetchWeather(for: "Test City", latitude: 40.7128, longitude: -74.0060)
            print("Test fetch successful. City: \(testData.city)")
        } catch {
            print("Test fetch failed with error: \(error)")
        }
    }
}

// This struct represents the structure of the API response
private struct APIResponse: Codable {
    let latitude: Double
    let longitude: Double
    let daily: DailyWeather
}
