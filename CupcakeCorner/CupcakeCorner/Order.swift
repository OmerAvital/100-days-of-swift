//
//  Order.swift
//  CupcakeCorner
//
//  Created by Omer Avital on 6/7/22.
//

import SwiftUI

class Order: ObservableObject, Codable {
    struct Details: Codable {
        static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
        
        var type = 0
        var quanity = 3
        
        var specialRequestEnabled = false {
            didSet {
                if specialRequestEnabled == false {
                    extraFrosting = false
                    addSprinkles = false
                }
            }
        }
        
        var extraFrosting = false
        var addSprinkles = false
        
        var name = ""
        var streetAddress = ""
        var city = ""
        var zipcode = ""
        
        var hasValidAddress: Bool {
            !(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
              || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
              || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
              || zipcode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        
        var cost: Double {
            // 2$ per cake
            var cost = Double(quanity) * 2
            
            // complicated cakes cost more
            cost += Double(type) / 2
            
            // $1/cake for extra frosting
            if extraFrosting {
                cost += Double(quanity)
            }
            
            // $0.50/cake for sprinkles
            if addSprinkles {
                cost += Double(quanity) / 2
            }
            
            return cost
        }
    }

    
    enum CodingKeys: CodingKey {
        case details
    }
    
    @Published var details = Details()
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(details, forKey: .details)
    }
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        details = try container.decode(Details.self, forKey: .details)
    }
}
