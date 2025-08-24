//
//  ListGamesResponseModel.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import Foundation

public struct ListGamesResponseModel: Codable, Equatable {
    public let count: Int
    public let next: String?
    public let games: [Game]
    
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case games = "results"
    }
}
