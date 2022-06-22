//
//  AddPersonView-ViewModel.swift
//  Challange6
//
//  Created by Omer Avital on 6/13/22.
//

import MapKit
import SwiftUI

extension AddPersonView {
    @MainActor class ViewModel: ObservableObject {
        @Published var uiImage: UIImage?
        
        private var id = UUID()
        @Published var name = ""
        @Published var notes = ""
        
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D.apple, latitudinalMeters: 1000, longitudinalMeters: 1000)
        @Published var usingLocation = false
        
        private let locationFetcher = LocationFetcher()
        
        func addLocation() {
            locationFetcher.start()
            
            if let location = locationFetcher.lastKnownLocation {
                mapRegion.center = location
            }
        }
        
        var person: Person {
            return Person(id: id, name: name, notes: notes, location: usingLocation ? mapRegion.center : nil)
        }
        
        init() { }
    }
}
