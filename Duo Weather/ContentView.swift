//
//  ContentView.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//
// ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherComparisonViewModel()
    @State private var selectedCities: [City] = []
    @State private var showingCitySelection = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Weather Compare")
                    .font(.largeTitle)

                Button("Select Cities") {
                    showingCitySelection = true
                }

                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else if !viewModel.weatherData.isEmpty {
                    Text("Weather data loaded")
                } else {
                    Text("No weather data")
                }
            }
            .onAppear {
                print("ContentView appeared")
            }
            .sheet(isPresented: $showingCitySelection) {
                NavigationView {
                    CitySelectionView(selectedCities: $selectedCities)
                        .navigationBarItems(trailing: Button("Done") {
                            showingCitySelection = false
                            print("Selected cities: \(selectedCities)")
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
            .onAppear {
                print("ContentView appeared")
                Task {
                    await WeatherService.shared.testFetch()
                }
            }
    }
}
