//
//  AddEditCityView.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/16.
//

import SwiftUI

struct AddEditCityView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var cityManager: CityManager
    @State private var name = ""
    @State private var latitude = ""
    @State private var longitude = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("City Name", text: $name)
                TextField("Latitude", text: $latitude)
                    .keyboardType(.decimalPad)
                TextField("Longitude", text: $longitude)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add City")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveCity()
                }
            )
        }
    }

    private func saveCity() {
        guard let lat = Double(latitude), let lon = Double(longitude) else { return }
        cityManager.addCity(name: name, latitude: lat, longitude: lon)
        presentationMode.wrappedValue.dismiss()
    }
}
