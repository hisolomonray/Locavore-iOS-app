//
//  Map.swift
//  CoffeeShop
//
//  Created by Solomon Ray on 6/3/23.
//


import SwiftUI
import MapKit

struct MapView: View {
    let address: String
    @Environment(\.presentationMode) var presentationMode // Add environment variable for presentation mode
    
    @State private var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @State private var placemark: CLPlacemark?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss the MapView when the close button is tapped
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: annotationItems) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    Image(systemName: "mappin")
                        .foregroundColor(.red)
                        .onTapGesture {
                            startNavigation()
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            if let placemark = placemark {
                Text("\(placemark.name ?? "")")
                Text("\(placemark.thoroughfare ?? "")")
                Text("\(placemark.locality ?? ""), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "")")
            }
        }
        .onAppear {
            getLocationCoordinates()
        }
    }
    private var annotationItems: [AnnotationItem] {
        if let placemark = placemark, let coordinate = placemark.location?.coordinate {
            return [AnnotationItem(coordinate: coordinate)]
        }
        return []
    }
    
    func getLocationCoordinates() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                // Handle error or no results
                return
            }
            
            self.placemark = placemark
            self.coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
    }
    
    func startNavigation() {
        guard let coordinate = placemark?.location?.coordinate else {
            return
        }
        
        // Use coordinate for navigation using a navigation service or app
        // Example: Launch Apple Maps with the destination coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.openInMaps(launchOptions: nil)
    }
    
    struct AnnotationItem: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}
