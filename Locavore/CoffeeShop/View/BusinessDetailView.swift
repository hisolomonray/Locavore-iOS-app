//
//  BusinessDetailView.swift
//  CoffeeShop
//
import SwiftUI
import Foundation
import Combine
import MapKit
import CoreLocation

struct BusinessDetailView: View {
    let business: Business
    let imageUrl: String?
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var imageLoader = ImageLoader()
    @State private var showingMap = false // State for presenting MapView
    
    @State private var coordinateRegion: MKCoordinateRegion?
    @State private var placemark: CLPlacemark?
    
    var fullAddress: String {
        var addressComponents: [String] = []
        
        addressComponents.append(business.location.address1)
        
        if let address2 = business.location.address2 {
            addressComponents.append(address2)
        }
        
        if let city = business.location.city {
            addressComponents.append(city)
        }
        
        if let state = business.location.state {
            addressComponents.append(state)
        }
        
        if let zipCode = business.location.zipCode {
            addressComponents.append(zipCode)
        }
        
        return addressComponents.joined(separator: ", ")
    }
    
    var distanceInMiles: Double {
        let metersToMilesConversionFactor = 0.000621371
        return business.distance * metersToMilesConversionFactor
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) { // Align VStack to the left
                HStack {
                    Text(business.name)
                        .font(.title)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                
                HStack { // Move YelpStarRatingView to the left
                    YelpStarRatingView(rating: business.rating)
                        .font(.subheadline)
                    
                    Spacer()
                }
                
                if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                    AsyncImageLoaderView(imageURL: url, imageLoader: imageLoader)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Adjust the frame to occupy the available space
                        .cornerRadius(10) // Apply corner radius
                } else {
                    ProgressView()
                        .frame(width: 200, height: 200)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                }

                
                VStack(alignment: .leading) {
                    Text("Location:")
                        .font(.headline)
                        .padding(.top)
                    
                    Text(fullAddress)
                        .font(.subheadline)
                        .padding(.bottom)
                }
                
                VStack(alignment: .leading) {
                    Text("Distance:")
                        .font(.headline)
                        .padding(.top)
                    
                    Text(String(format: "%.2f miles", distanceInMiles))
                        .font(.subheadline)
                        .padding(.bottom)
                }
                
                Spacer()
                
                Button(action: {
                    showingMap = true
                }) {
                    Text("Get Directions")
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showingMap) {
                    MapView(address: fullAddress)
                }
                .padding()
                .onAppear {
                    if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                        imageLoader.loadImage(from: url)
                    }
                }
                .onDisappear {
                    imageLoader.cancel()
                }
            }
            .padding(.horizontal) // Add horizontal padding to align the content within the ScrollView
        }
    }
}
