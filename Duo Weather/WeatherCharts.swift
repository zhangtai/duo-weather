//
//  WeatherCharts.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//

import SwiftUI
import Charts

struct TemperatureChart: View {
    let weatherData: [WeatherData]

    var body: some View {
        Chart {
            ForEach(weatherData) { cityData in
                ForEach(Array(zip(cityData.daily.time, zip(cityData.daily.temperatureMin, cityData.daily.temperatureMax))), id: \.0) { date, temps in
                    AreaMark(
                        x: .value("Date", weekdayFrom(dateString: date)),
                        yStart: .value("Min Temp", temps.0),
                        yEnd: .value("Max Temp", temps.1)
                    )
                    .foregroundStyle(by: .value("City", cityData.city))
                    .opacity(0.5)
                }

                // Add a line for the average temperature
                ForEach(Array(zip(cityData.daily.time, zip(cityData.daily.temperatureMin, cityData.daily.temperatureMax))), id: \.0) { date, temps in
                    LineMark(
                        x: .value("Date", weekdayFrom(dateString: date)),
                        y: .value("Avg Temp", (temps.0 + temps.1) / 2)
                    )
                    .foregroundStyle(by: .value("City", cityData.city))
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 7)) { value in
                AxisValueLabel {
                    if let weekday = value.as(String.self) {
                        Text(weekday)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartLegend(position: .bottom, alignment: .center)
        .frame(height: 300)
        .padding()
    }
}

struct PrecipitationChart: View {
    let weatherData: [WeatherData]

    var body: some View {
        Chart {
            ForEach(weatherData) { cityData in
                ForEach(Array(zip(cityData.daily.time, cityData.daily.precipitation)), id: \.0) { date, precip in
                    BarMark(
                        x: .value("Date", weekdayFrom(dateString: date)),
                        y: .value("Precipitation", precip)
                    )
                    .foregroundStyle(by: .value("City", cityData.city))
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 7)) { value in
                AxisValueLabel {
                    if let weekday = value.as(String.self) {
                        Text(weekday)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartLegend(position: .bottom, alignment: .center)
        .frame(height: 300)
        .padding()
    }
}

// Helper function to convert date string to weekday abbreviation
func weekdayFrom(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }

    return ""
}
