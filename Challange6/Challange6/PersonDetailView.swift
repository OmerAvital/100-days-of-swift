//
//  PersonDetailView.swift
//  Challange6
//
//  Created by Omer Avital on 6/13/22.
//

import MapKit
import SwiftUI

struct PersonDetailView: View {
    let person: Person
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    if let image = person.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(.primary)
                                .opacity(0.2)
                            Text("No image found")
                        }
                    }
                }
                .frame(height: 300)
                .cornerRadius(10)
                .padding()
                
                Text(person.name)
                    .font(.title.bold())

                if !person.notes.isEmpty {
                    Divider()
                    
                    Text("Notes")
                        .underline()
                        .padding(.bottom)
                    
                    Text(person.notes)
                }
                
                if let location = person.location {
                    Divider()
                    
                    Text("Location")
                        .underline()
                    
                    ZStack {
                        Map(coordinateRegion: .constant(MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)))
                        
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35, alignment: .bottom)
                            .foregroundColor(.red)
                            .shadow(color: .white.opacity(0.75), radius: 3, x: 0, y: 2)
                    }
                        .disabled(true)
                        .frame(height: 300)
                }
            }
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PersonDetailView(person: Person.example)
        }
    }
}
