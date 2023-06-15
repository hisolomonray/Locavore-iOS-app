
//  Business.swift
//  CoffeeShop
//
//  Created by Solomon Ray on 5/17/23.
//
// Business.swift
class Business: Codable, Identifiable, Hashable {
    var id: String?
    let name: String
    let rating: Double
    let price: String?
    let phone: String
    let imageUrl: String?
    let location: Location
    let hours: [BusinessHours]?
    let distance: Double
    
    enum CodingKeys: String, CodingKey {
        case id, name, rating, price, phone, imageUrl, location, hours, distance
    }
    
    init(id: String, name: String, rating: Double, price: String?, phone: String, imageUrl: String?, location: Location, hours: [BusinessHours]?, distance: Double) {
        self.id = id
        self.name = name
        self.rating = rating
        self.price = price
        self.phone = phone
        self.imageUrl = imageUrl
        self.location = location
        self.hours = hours
        self.distance = distance
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decode(Double.self, forKey: .rating)
        price = try container.decodeIfPresent(String.self, forKey: .price)
        phone = try container.decode(String.self, forKey: .phone)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        location = try container.decode(Location.self, forKey: .location)
        hours = try container.decodeIfPresent([BusinessHours].self, forKey: .hours)
        distance = try container.decode(Double.self, forKey: .distance)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Business, rhs: Business) -> Bool {
        return lhs.id == rhs.id
    }
}
