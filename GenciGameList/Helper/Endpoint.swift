//
//  Endpoint.swift
//  GenciGameList
//
//  Created by naswakhansa on 24/08/25.
//

import Foundation

enum Endpoint {
    case games(page: Int, search: String?)
    case gameDetail(id: Int)

    var path: String {
        switch self {
        case .games: return "/games"
        case .gameDetail(let id): return "/games/\(id)"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .games(let page, let search):
            var items: [URLQueryItem] = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "key", value: APIConfig.apiKey)
            ]
            if let search { items.append(URLQueryItem(name: "search", value: search)) }
            return items
        case .gameDetail:
            return [URLQueryItem(name: "key", value: APIConfig.apiKey)]
        }
    }
}
