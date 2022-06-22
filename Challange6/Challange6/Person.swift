//
//  Person.swift
//  Challange6
//
//  Created by Omer Avital on 6/13/22.
//

import MapKit
import SwiftUI

struct Person: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let notes: String
    
    private let latitude: Double?
    private let longitude: Double?
    var location: CLLocationCoordinate2D? {
        guard let latitude = latitude,
              let longitude = longitude
        else { return nil }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    let imagePath: URL
    var image: Image? {
        do {
            let data = try Data(contentsOf: imagePath)
            guard let uiImage = UIImage(data: data) else { return nil }
            return Image(uiImage: uiImage)
        } catch {
            print("Could not laod image: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID, name: String, notes: String, location: CLLocationCoordinate2D?) {
        self.id = id
        self.name = name
        self.notes = notes
        
        self.imagePath = Self.imagesFolderPath.appendingPathComponent("\(id)", conformingTo: .png)
        
        latitude = location?.latitude
        longitude = location?.longitude
    }
    
    static var imagesFolderPath: URL {
        let url = FileManager.documentsDirectory.appendingPathComponent("images", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
        } catch {
            print("Could not create directory: \(error.localizedDescription)")
        }
        return url
    }
    static let example = Self(id: UUID(), name: "Omer", notes: "Me", location: CLLocationCoordinate2D.apple)
}
