//
//  GameDetailResponseModel.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import Foundation

public struct GameDetailResponseModel: Codable {
    public let id: Int
    public let name: String?
    public let description: String?
    public let metacritic: Int?
    public let backgroundImage: String?
    public let platforms: [Platforms]?
    public let genres: [Developers]?
    public let developers: [Developers]?
    public let rating: Double?
    public let released: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description = "description_raw"
        case metacritic
        case backgroundImage = "background_image"
        case platforms
        case genres
        case developers
        case rating
        case released
    }
    
    public var formattedRating: String {
        if let rating = rating {
            return String(format: "%.1f", rating)
        }
        return "N/A"
    }
}

public struct Developers: Codable {
    public let id: Int
    public let name: String
}

public struct Platforms: Codable {
    public let platform: PlatformDetail
}

public struct PlatformDetail: Codable {
    public let id: Int
    public let name: String
}
