//
//  ContentView.swift
//  Duo Weather
//
//  Created by zhangt.ai on 2024/9/14.
//

import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = WeatherComparisonViewModel()
    @State private var selectedCities: [City] = []
    @State private var showingCitySelection = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else if !viewModel.weatherData.isEmpty {
                        MapView(cities: selectedCities)
                            .padding(.horizontal)

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
                .padding()
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
        .onAppear {
            let cityManager = CityManager(modelContext: modelContext)
            if cityManager.getAllCities().isEmpty {
                cityManager.preloadCities()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
