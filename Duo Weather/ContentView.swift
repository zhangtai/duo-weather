//
//  ContentView.swift
//  Duo Weather
//
//  Created by zhangt.ai on 2024/9/14.
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
                        Text("Temperature")
                            .font(.headline)
                        TemperatureChart(weatherData: viewModel.weatherData)

                        Text("Precipitation")
                            .font(.headline)
                        PrecipitationChart(weatherData: viewModel.weatherData)
                    } else {
                        Text("Select cities to compare weather")
                    }
                }
            }
            .navigationTitle("Duo Weather")
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
                            if !selectedCities.isEmpty {
                                Task {
                                    await viewModel.fetchWeatherData(for: selectedCities)
                                }
                            } else {
                                viewModel.weatherData.removeAll()
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
