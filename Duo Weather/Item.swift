//
//  Item.swift
//  Duo Weather
//
//  Created by Tying on 2024/9/14.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
