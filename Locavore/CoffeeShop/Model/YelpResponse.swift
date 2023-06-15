//
//  YelpResponse.swift
//  CoffeeShop
//
//  Created by Solomon Ray on 5/17/23.
//

import Foundation
import Combine


struct YelpBusinessesSearchResponse: Codable {
    let businesses: [Business]
    let total: Int
    let region: Region
    let hours: [Hour]? 
}

struct Region: Codable {
    let center: Coordinate
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

struct Hour: Codable {
    let open: [Open]
    let hoursType: String?
    let isOpenNow: Bool
}

struct Open: Codable {
    let isOvernight: Bool
    let start: String
    let end: String
    let day: Int
}
