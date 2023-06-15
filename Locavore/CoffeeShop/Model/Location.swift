//
//  Location.swift
//  CoffeeShop
//
//  Created by Solomon Ray on 5/17/23.
//

import Foundation
import CoreLocation

struct Location: Codable, Identifiable {
    var id: UUID?
    var coordinate: CLLocationCoordinate2DWrapper?
    var placemark: Placemark?
    var address1: String
    var address2: String?
    var city: String?
    var state: String?
    var zipCode: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case coordinate, placemark, address1, address2, city, state, zipCode
    }

    struct CLLocationCoordinate2DWrapper: Codable {
        let latitude: CLLocationDegrees
        let longitude: CLLocationDegrees

        init(_ coordinate: CLLocationCoordinate2D) {
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
        }

        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }

    struct Placemark: Codable {
        var name: String?
        var thoroughfare: String?
        var locality: String?
        var administrativeArea: String?
        var postalCode: String?
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(UUID.self, forKey: .id)
        address1 = try container.decode(String.self, forKey: .address1)
        address2 = try container.decodeIfPresent(String.self, forKey: .address2)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        zipCode = try container.decodeIfPresent(String.self, forKey: .zipCode)
        placemark = try container.decodeIfPresent(Placemark.self, forKey: .placemark)

        if let coordinateWrapper = try container.decodeIfPresent(CLLocationCoordinate2DWrapper.self, forKey: .coordinate) {
            coordinate = coordinateWrapper
        } else {
            coordinate = nil
        }
    }
}
