//
//  EditView.swift
//  BucketList
//
//  Created by Omer Avital on 6/10/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("")
                    case .loaded:
                        ForEach(viewModel.pagesToShow, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                        
                        if viewModel.maxResults < viewModel.pages.count {
                            Button("Show more") {
                                viewModel.showMorePages()
                            }
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                } header: {
                    HStack {
                        Text("Nearby")
                        
                        if viewModel.loadingState == .loading {
                            ProgressView()
                        }
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    onSave(viewModel.newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        _viewModel = StateObject(wrappedValue: ViewModel(location: location))
        self.onSave = onSave
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
