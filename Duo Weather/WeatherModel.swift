//
//  WeatherModel.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//

import Foundation

struct WeatherData: Codable, Identifiable, Equatable {
    let id = UUID()
    let city: String
    let latitude: Double
    let longitude: Double
    let daily: DailyWeather

    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        lhs.id == rhs.id &&
        lhs.city == rhs.city &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude &&
        lhs.daily == rhs.daily
    }
}

struct DailyWeather: Codable, Equatable {
    let time: [String]
    let temperatureMax: [Double]
    let temperatureMin: [Double]
    let precipitation: [Double]
    let sunrise: [String]
    let sunset: [String]

    enum CodingKeys: String, CodingKey {
        case time
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case precipitation = "precipitation_sum"
        case sunrise
        case sunset
    }
}
