//
//  ContentView-ViewModel.swift
//  Challange6
//
//  Created by Omer Avital on 6/13/22.
//

import SwiftUI

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var people: [Person]
        
        private let dataPath = FileManager.documentsDirectory.appendingPathComponent("people.json")
        
        init() {
            do {
                let data = try Data(contentsOf: dataPath)
                
                people = try JSONDecoder().decode([Person].self, from: data)
            } catch {
                people = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(people)
                try data.write(to: dataPath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Failed to save data.")
            }
        }

        func add(person: Person, uiImage: UIImage) {
            do {
                guard let data = uiImage.pngData() else {
                    print("Failed to get image data.")
                    return
                }
                try data.write(to: person.imagePath, options: [.atomic, .completeFileProtection])
                people.append(person)
                save()
            } catch {
                print("Failed to add person: \(error.localizedDescription)")
            }
        }
        
        func remove(atOffsets offsets: IndexSet) {
            for i in offsets {
                do {
                    try FileManager.default.removeItem(at: people[i].imagePath)
                } catch {
                    print("Cannot delete image: \(error.localizedDescription)")
                }
            }
            people.remove(atOffsets: offsets)
            save()
        }
    }
}
