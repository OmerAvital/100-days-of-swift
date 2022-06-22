//
//  ContentView.swift
//  Challange6
//
//  Created by Omer Avital on 6/13/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.people) { person in
                    NavigationLink {
                        PersonDetailView(person: person)
                    } label: {
                        HStack {
                            Group {
                                if let image = person.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    ZStack {
                                        Color.primary
                                            .opacity(0.1)
                                        Text("No image")
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                                .frame(width: 50, height: 50)
                                .clipShape(
                                    Circle()
                                )

                            Text(person.name)
                        }
                    }
                }
                .onDelete { offsets in
                    viewModel.remove(atOffsets: offsets)
                }
            }
            .navigationTitle("Name Saver")
            .toolbar {
                Button {
                    showingAddView = true
                } label: {
                    Label("Add a new person", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddPersonView { person, uiImage in
                    viewModel.add(person: person, uiImage: uiImage)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
