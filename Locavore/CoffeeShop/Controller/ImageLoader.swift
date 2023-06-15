
//  ImageLoader.swift
//  CoffeeShop
//  Created by Solomon Ray on 5/30/23.


import SwiftUI
import Combine
import Foundation


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var error: Error?
    
    private var cancellable: AnyCancellable?
    
    func loadImage(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .handleEvents(receiveOutput: { data in
                print("Image data received: \(data)")
            })
            .map { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.error = error
                        print("Error loading image: \(error)")
                    }
                },
                receiveValue: { [weak self] image in
                    self?.image = image
                    self?.error = nil
                    print("Image loaded")
                }
            )
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}



struct AsyncImageLoaderView: View {
    @ObservedObject private var imageLoader: ImageLoader
    private let imageURL: URL
    private let placeholderImage: Image
    
    init(imageURL: URL, imageLoader: ImageLoader, placeholderImage: Image = Image(systemName: "photo")) {
        self.imageURL = imageURL
        self.imageLoader = imageLoader
        self.placeholderImage = placeholderImage
    }
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Adjust the frame to occupy the available space
                .cornerRadius(10)
        } else {
            if let error = imageLoader.error {
                Text("Error loading image: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else {
                placeholderImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Adjust the frame to occupy the available space
                    .cornerRadius(10)
            }
        }
    }
}
