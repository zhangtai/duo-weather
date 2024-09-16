//
//  CityManager.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/16.
//

import Foundation
import CoreData

class CityManager: ObservableObject {
    @Published var cities: [City] = []

    private let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Duo Weather")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        fetchCities()
    }

    func fetchCities() {
        let request: NSFetchRequest<City> = City.fetchRequest()
        do {
            cities = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching cities: \(error)")
        }
    }

    func addCity(name: String, latitude: Double, longitude: Double) {
        let newCity = City(context: container.viewContext)
        newCity.name = name
        newCity.latitude = latitude
        newCity.longitude = longitude
        saveContext()
    }

    func updateCity(_ city: City) {
        saveContext()
    }

    func deleteCity(_ city: City) {
        container.viewContext.delete(city)
        saveContext()
    }

    private func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                fetchCities()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
