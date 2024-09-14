//
//  WeatherModel.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//

import Foundation

struct WeatherData: Codable, Identifiable {
    let id = UUID()
    let city: String
    let latitude: Double
    let longitude: Double
    let daily: DailyWeather

    init(city: String, latitude: Double, longitude: Double, daily: DailyWeather) {
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        self.daily = daily
    }
}

struct DailyWeather: Codable {
    let time: [String]
    let temperatureMax: [Double]
    let temperatureMin: [Double]
    let precipitation: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case precipitation = "precipitation_sum"
    }
}
