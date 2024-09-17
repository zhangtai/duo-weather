//
//  City.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/17.
//

import Foundation
import SwiftData

@Model
class City {
    var name: String
    var latitude: Double
    var longitude: Double

    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
