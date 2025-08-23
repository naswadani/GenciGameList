//
//  Game.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import Foundation

public struct Game: Identifiable, Codable, Equatable {
    public let id: Int
    public let name: String?
    public let released: String?
    public let backgroundImage: String?
    public let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
    }
    
    public var formattedRating: String {
        if let rating = rating {
            return String(format: "%.1f", rating)
        }
        return "N/A"
    }
}
