//
//  Item.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/25.
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
