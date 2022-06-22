//
//  AddPersonView.swift
//  Challange6
//
//  Created by Omer Avital on 6/13/22.
//

import MapKit
import SwiftUI

struct AddPersonView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()
    
    @State private var showingImagePicker = false
    var onAdd: (Person, UIImage) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Image") {
                    if let uiImage = viewModel.uiImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    Button(viewModel.uiImage == nil ? "Add Image" : "Change Image") {
                        showingImagePicker = true
                    }
                }
                
                Section("Details") {
                    HStack {
                        Text("Name: ")
                            .font(.headline)
                        TextField("John Doe", text: $viewModel.name)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Notes:")
                            .font(.headline)
                        TextEditor(text: $viewModel.notes)
                    }
                }
                
                Section("Location") {
                    if viewModel.usingLocation {
                        ZStack {
                            Map(coordinateRegion: $viewModel.mapRegion)
                                .frame(height: 300)
                            
                            Image(systemName: "mappin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35, alignment: .bottom)
                                .foregroundColor(.red)
                                .shadow(color: .white.opacity(0.75), radius: 3, x: 0, y: 2)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    Toggle("Add location", isOn: $viewModel.usingLocation.animation())
                }
            }
            .navigationTitle("Add Person")
            .toolbar {
                Button("Done") {
                    guard let uiImage = viewModel.uiImage else { return }
                    onAdd(viewModel.person, uiImage)
                    dismiss()
                }
                .disabled(viewModel.uiImage == nil)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $viewModel.uiImage)
            }
        }
    }
    
    init(onAdd: @escaping (Person, UIImage) -> Void) {
        self.onAdd = onAdd
    }
}

struct AddPerson_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView() { _, _ in }
    }
}
