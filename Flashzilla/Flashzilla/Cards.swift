//
//  Cards.swift
//  Flashzilla
//
//  Created by Omer Avital on 6/15/22.
//

import SwiftUI

@MainActor class Cards: ObservableObject, DataSaver {
    typealias SavedData = [Card]
    
    @Published private(set) var current: [Card]
    @Published private(set) var all: [Card]
    
    static internal let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("cards", conformingTo: .json)
    
    init() {
        let cards = Self.load() ?? []
        all = cards
        current = cards
    }
    
    private func save() {
        _ = Self.save(all)
        reset()
    }
    
    func reset() {
        current = all
    }
    
    func remove(_ card: Card, didGetRight: Bool) {
        guard let index = current.firstIndex(of: card) else { return }
        
        withAnimation {
            current.remove(at: index)
            
            if !didGetRight {
                current.insert(card, at: 0)
            }
        }
    }
    
    func removeTop(didGetRight: Bool) {
        if let topCard = current.last {
            remove(topCard, didGetRight: didGetRight)
        }
    }
    
    func add(_ card: Card) {
        all.append(card)
        save()
    }
    
    func delete(atOffsets offsets: IndexSet) {
        all.remove(atOffsets: offsets)
        save()
    }
}
