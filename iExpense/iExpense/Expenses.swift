//
//  Expenses.swift
//  iExpense
//
//  Created by Omer Avital on 6/3/22.
//

import Foundation

class Expenses: ObservableObject {
    static let ITEMS_USER_DEFAULT_KEY = "Items"
    
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: Self.ITEMS_USER_DEFAULT_KEY)
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: Self.ITEMS_USER_DEFAULT_KEY),
           let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
            items = decodedItems
            return
        }
        items = []
    }
}
