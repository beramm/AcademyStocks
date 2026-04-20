//
//  Item.swift
//  Ch2StockApp
//
//  Created by bram raiskay chandra on 20/04/26.
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
