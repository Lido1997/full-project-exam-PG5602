//
//  Item.swift
//  NewsWorldwide
//
//  Created by Aslak Lid Johansen on 03/12/2024.
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
