//
//  CitySelectionView.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//

import SwiftUI
import SwiftData

struct CitySelectionView: View {
    @Binding var selectedCities: [City]
    @Query private var cities: [City]
    @State private var showingAddCity = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            ForEach(cities) { city in
                Button(action: {
                    toggleCitySelection(city)
                }) {
                    HStack {
                        Text(city.name)
                        Spacer()
                        if selectedCities.contains(where: { $0.id == city.id }) {
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
            AddEditCityView()
        }
    }

    private func toggleCitySelection(_ city: City) {
        if let index = selectedCities.firstIndex(where: { $0.id == city.id }) {
            selectedCities.remove(at: index)
        } else {
            selectedCities.append(city)
        }
    }

    private func deleteCity(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(cities[index])
        }
    }
}
