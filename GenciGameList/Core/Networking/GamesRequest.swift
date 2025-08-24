//
//  GamesRequest.swift
//  GenciGameList
//
//  Created by naswakhansa on 24/08/25.
//

import Foundation

public enum GamesRequest {
    case first(page: Int, search: String?)
    case next(url: String)
}
