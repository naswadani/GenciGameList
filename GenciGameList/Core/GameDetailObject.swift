//
//  GameDetailObject.swift
//  GenciGameList
//
//  Created by naswakhansa on 26/08/25.
//

import Foundation
import RealmSwift

public class GameDetailObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String?
    @Persisted var gameDescription: String?
    @Persisted var metacritic: Int?
    @Persisted var backgroundImage: String?
    @Persisted var rating: Double?
    @Persisted var released: String?
    
    @Persisted var platforms = List<PlatformObject>()
    @Persisted var genres = List<DeveloperObject>()
    @Persisted var developers = List<DeveloperObject>()
    
    var formattedRating: String {
        if let rating = rating {
            return String(format: "%.1f", rating)
        }
        return "N/A"
    }
}

class DeveloperObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
}

class PlatformObject: Object {
    @Persisted var platform: PlatformDetailObject?
}

class PlatformDetailObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
}
