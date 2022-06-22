//
//  Activities.swift
//  Habbit Tracking (Challange 4)
//
//  Created by Omer Avital on 6/5/22.
//

import Foundation

class Activities: ObservableObject {
    static let KEY = "activities"
    
    @Published var items = [Activity]() {
        didSet {
            saveData()
        }
    }
    
    init() {
        getData()
    }
    
    private func getData() {
        guard let savedData = UserDefaults.standard.data(forKey: Self.KEY) else {
            return
        }
        
        if let decodedData = try? JSONDecoder().decode([Activity].self, from: savedData) {
            items = decodedData
        }
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: Self.KEY)
        }
    }
    
    func complete(_ activity: Activity) {
        if let activityIndex = items.firstIndex(of: activity) {
            items[activityIndex].totalCompleted += 1
            items[activityIndex].lastCompletedOn = Date.now
        }
    }
    
    func delete(_ activity: Activity) {
        if let activityIndex = items.firstIndex(of: activity) {
            items.remove(at: activityIndex)
        }
    }
}
