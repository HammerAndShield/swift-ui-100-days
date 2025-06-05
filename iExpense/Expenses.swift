//
//  Expenses.swift
//  SwiftUI100Days
//
//  Created by austin townsend on 6/4/25.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    var personal: [ExpenseItem] {
        items.filter { $0.type == "Personal" }
    }
    
    var business: [ExpenseItem] {
        items.filter { $0.type == "Business" }
    }
    
    var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
    }
}
