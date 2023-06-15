//  YelpSearchController.swift
//  CoffeeShop
//
//  Created by Solomon Ray on 5/17/23.
//

import Foundation
import SwiftUI
import Combine

class YelpSearchController: ObservableObject {
    @Published var businesses: [Business] = []
    @Published var searchTerm: String = ""
    @Published var location: String = ""
    @Published var selectedBusiness: Business?
    @Published var searchTermSuggestions: [SearchTermSuggestion] = [] // Define the searchTermSuggestions property
    
    // Add focus properties
    @Published var isSearchTermFocused: Bool = false
    @Published var isLocationFocused: Bool = false
    @FocusState private var searchTermFocus: Bool
    @FocusState private var locationFocus: Bool
    
    private var cancellables: Set<AnyCancellable> = []
    
    func performSearch() {
        let apiKey = "Bearer wumDdALZA7WVNuiDcCg6Am9hToc3_0XNN5SCQgx_5VlhlYlOTya4pfbFWbNz1meZ9wEPvMkdJkKZ26XEGjzZ-tmOKcgek2ey-42x9NWY5ME32pjRVoKqlfl3ubN3ZHYx"
        
        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error: Failed to encode search term or location.")
            return
        }
        
        let urlString = "https://api.yelp.com/v3/businesses/search?term=\(encodedSearchTerm)&location=\(encodedLocation)"
        
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                print("Response status code: \(httpResponse.statusCode)")
                return data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error decoding Yelp API response: \(error)")
                }
            }, receiveValue: { [weak self] data in
                // Print the received data before decoding
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received data: \(jsonString)")
                }
                
                // Decode the JSON data
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(YelpBusinessesSearchResponse.self, from: data)
                    self?.businesses = result.businesses
                    print("Decoded businesses: \(result.businesses)")
                } catch {
                    print("Error decoding Yelp API response: \(error)")
                }
            })
            .store(in: &cancellables)
    }
}


