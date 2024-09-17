//
//  CitySelectionView.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//
import SwiftUI

struct CitySelectionView: View {
    @Binding var selectedCities: [City]
    @ObservedObject var cityManager: CityManager
    @State private var showingAddCity = false

    var body: some View {
        List {
            ForEach(cityManager.cities, id: \.self) { city in
                Button(action: {
                    toggleCitySelection(city)
                }) {
                    HStack {
                        Text(city.name ?? "")
                        Spacer()
                        if selectedCities.contains(where: { $0.objectID == city.objectID }) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .onDelete(perform: deleteCity)
        }
        .navigationTitle("Select Cities")
        .toolbar {
            Button(action: { showingAddCity = true }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddCity) {
            AddEditCityView(cityManager: cityManager)
        }
    }

    private func toggleCitySelection(_ city: City) {
        if let index = selectedCities.firstIndex(where: { $0.objectID == city.objectID }) {
            selectedCities.remove(at: index)
        } else {
            selectedCities.append(city)
        }
    }

    private func deleteCity(at offsets: IndexSet) {
        offsets.forEach { index in
            let city = cityManager.cities[index]
            cityManager.deleteCity(city)
        }
    }
}
