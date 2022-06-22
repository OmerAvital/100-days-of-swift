//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Omer Avital on 6/13/22.
//

import Foundation

extension EditView {
    enum LoadingState {
        case loading, loaded, failed
    }

    @MainActor class ViewModel: ObservableObject {
        var location: Location

        @Published var name: String
        @Published var description: String
        
        @Published var loadingState = LoadingState.loading
        @Published var pages = [Page]()
        @Published var maxResults = 10
        
        var pagesToShow: [Page] {
            if pages.count - maxResults == 1 {
                maxResults += 1
            }
            let numToShow = min(maxResults, pages.count)
            
            return Array(pages[..<numToShow])
        }
        
        var newLocation: Location {
            Location(id: UUID(), name: name, description: description, latitude: location.latitude, longitude: location.longitude)
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                loadingState = .failed
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                pages = items.query.pages.values.sorted()
                maxResults = 5
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
        func showMorePages() {
            maxResults += 5
        }
        
        init(location: Location) {
            self.location = location
            name = location.name
            description = location.description
        }
    }
}
