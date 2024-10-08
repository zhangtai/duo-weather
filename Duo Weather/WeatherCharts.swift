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
    @State private var dragLocation: CGPoint = .zero
    @State private var isDragging: Bool = false
    @State private var selectedDate: String = ""
    @State private var selectedTemps: [(city: String, minTemp: Int, maxTemp: Int)] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Chart {
                    ForEach(weatherData) { cityData in
                        temperatureAreaMarks(for: cityData)
                        temperatureLineMarks(for: cityData)
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

                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let location = value.location
                            dragLocation = location
                            isDragging = true
                            updateSelectedData(at: location, in: geometry.size)
                        }
                        .onEnded { _ in
                            isDragging = false
                        }
                )

                if isDragging {
                    // Draw the vertical line
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 2, height: 300)
                        .position(x: dragLocation.x, y: 150) // 150 is half of the chart height
                }
            }

            if isDragging {
                VStack(alignment: .leading) {
                    Text("Date: \(selectedDate)")
                    ForEach(selectedTemps, id: \.city) { temp in
                        Text("\(temp.city): \(temp.minTemp) / \(temp.maxTemp)")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
            }
        }
        .chartLegend(position: .bottom, alignment: .center)
        .frame(height: 300)
        .padding()
    }

    private func temperatureAreaMarks(for cityData: WeatherData) -> some ChartContent {
        ForEach(Array(zip(cityData.daily.time, zip(cityData.daily.temperatureMin, cityData.daily.temperatureMax)).enumerated()), id: \.element.0) { index, element in
            let (date, temps) = element
            AreaMark(
                x: .value("Date", weekdayFrom(dateString: date)),
                yStart: .value("Min Temp", temps.0),
                yEnd: .value("Max Temp", temps.1)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(by: .value("City", cityData.city))
            .opacity(0.3)
        }
    }

    private func temperatureLineMarks(for cityData: WeatherData) -> some ChartContent {
        ForEach(Array(zip(cityData.daily.time, zip(cityData.daily.temperatureMin, cityData.daily.temperatureMax)).enumerated()), id: \.element.0) { index, element in
            let (date, temps) = element
            LineMark(
                x: .value("Date", weekdayFrom(dateString: date)),
                y: .value("Avg Temp", (temps.0 + temps.1) / 2)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(by: .value("City", cityData.city))
        }
    }

    private func weekdayFrom(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEE"
            return weekdayFormatter.string(from: date)
        }
        return ""
    }

    private func updateSelectedData(at location: CGPoint, in size: CGSize) {
        // Convert the drag location to the corresponding data point
        let chartWidth = size.width

        // Find the nearest data point
        let index = Int(location.x / (chartWidth / CGFloat(weatherData[0].daily.time.count)))
        if index >= 0 && index < weatherData[0].daily.time.count {
            selectedDate = weatherData[0].daily.time[index]
            selectedTemps = weatherData.map { cityData in
                let minTemp = Int(cityData.daily.temperatureMin[index])
                let maxTemp = Int(cityData.daily.temperatureMax[index])
                return (city: cityData.city, minTemp: minTemp, maxTemp: maxTemp)
            }
        }
    }
}


struct PrecipitationChart: View {
    let weatherData: [WeatherData]

    var body: some View {
        Chart {
            ForEach(weatherData) { cityData in
                ForEach(cityData.daily.time.indices, id: \.self) { index in
                    BarMark(
                        x: .value("Date", weekdayFrom(dateString: cityData.daily.time[index])),
                        y: .value("Precipitation", cityData.daily.precipitation[index])
                    )
                    .foregroundStyle(by: .value("City", cityData.city))
                    .position(by: .value("City", cityData.city))
                    .annotation(position: .top) {
                        Text(String(format: "%.1f", cityData.daily.precipitation[index]))
                            .font(.caption2)
                            .offset(y: -5)
                    }
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
    }
}

struct SunriseSunsetChart: View {
    let weatherData: [WeatherData]

    var body: some View {
        Chart {
            ForEach(weatherData) { cityData in
                ForEach(cityData.daily.time.indices, id: \.self) { index in
                    BarMark(
                        x: .value("Date", weekdayFrom(dateString: cityData.daily.time[index])),
                        yStart: .value("Sunrise", timeToMinutes(cityData.daily.sunrise[index])),
                        yEnd: .value("Sunset", timeToMinutes(cityData.daily.sunset[index]))
                    )
                    .foregroundStyle(by: .value("City", cityData.city))
                    .position(by: .value("City", cityData.city))
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
            AxisMarks(values: .automatic(desiredCount: 6)) { value in
                AxisValueLabel {
                    if let minutes = value.as(Double.self) {
                        Text(minutesToTimeString(Int(minutes)))
                    }
                }
            }
        }
        .chartLegend(position: .bottom, alignment: .center)
    }
}

// Helper function to convert time string to minutes since midnight
func timeToMinutes(_ timeString: String) -> Double {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
    if let date = formatter.date(from: timeString) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        return Double(components.hour! * 60 + components.minute!)
    }
    return 0
}

// Helper function to convert minutes since midnight to time string
func minutesToTimeString(_ minutes: Int) -> String {
    let hours = minutes / 60
    let mins = minutes % 60
    return String(format: "%02d:%02d", hours, mins)
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
