//
//  ContentView.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherComparisonViewModel()
    @State private var selectedCities: [City] = []
    @State private var showingCitySelection = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else if !viewModel.weatherData.isEmpty {
                        Text("Temperature Comparison")
                            .font(.headline)
                        TemperatureChart(weatherData: viewModel.weatherData)

                        Text("Precipitation Comparison")
                            .font(.headline)
                        PrecipitationChart(weatherData: viewModel.weatherData)
                    } else {
                        Text("Select cities to compare weather")
                    }
                }
            }
            .navigationTitle("Weather Compare")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Select Cities") {
                        showingCitySelection = true
                    }
                }
            }
            .sheet(isPresented: $showingCitySelection) {
                NavigationView {
                    CitySelectionView(selectedCities: $selectedCities)
                        .navigationBarItems(trailing: Button("Done") {
                            showingCitySelection = false
                            Task {
                                await viewModel.fetchWeatherData(for: selectedCities)
                            }
                        })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
