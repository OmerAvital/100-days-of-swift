//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Omer Avital on 6/13/22.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location]
        @Published var selectedPlace: Location?
        @Published private(set) var isUnlocked = false
        
        @Published var showingErrorAlert = false
        @Published private(set) var errorAlertTitle = ""
        @Published private(set) var errorAlertMessage = ""
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation() {
            if locations.first(where: { $0.coordinate.longitude == mapRegion.center.longitude && $0.coordinate.latitude == mapRegion.center.latitude }) != nil {
                errorAlert(title: "New location failed", message: "There is already a location in that place.")
                return
            }
            
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    Task { @MainActor in
                        if success {
                                self.isUnlocked = true
                        } else {
                            self.errorAlert(title: "Failed to authenticate", message: "Please try again later.")
                        }
                    }
                }
            } else {
                errorAlert(title: "Biometrics Unavailable", message: "Enable biometrics to proceed.")
            }
        }
        
        func errorAlert(title: String, message: String) {
            errorAlertTitle = title
            errorAlertMessage = message
            showingErrorAlert = true
        }
    }
}
