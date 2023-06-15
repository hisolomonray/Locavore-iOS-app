//
//  BusinessHours.swift
//  CoffeeShop
//
//  Created by Solomon Ray on 5/24/23.
//

import Foundation
import SwiftUI


struct BusinessHours: Codable, Identifiable {
    var id = UUID()
    let day: String
    let start: String?  // Make sure start is defined as optional string
    let end: String?
}
