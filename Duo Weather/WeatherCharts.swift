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
                ForEach(Array(zip(cityData.daily.time, cityData.daily.temperatureMax)), id: \.0) { date, temp in
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Temperature", temp)
                    )
                    .foregroundStyle(by: .value("City", cityData.city))
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5))
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
                        x: .value("Date", date),
                        y: .value("Precipitation", precip)
                    )
                    .foregroundStyle(by: .value("City", cityData.city))
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5))
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartLegend(position: .bottom, alignment: .center)
        .frame(height: 300)
        .padding()
    }
}
