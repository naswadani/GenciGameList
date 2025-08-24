//
//  Extension.swift
//  GenciGameList
//
//  Created by naswakhansa on 25/08/25.
//

import Foundation

extension String {
    func extractPageNumber() -> Int? {
        guard let url = URLComponents(string: self) else { return nil }
        return url.queryItems?
            .first(where: { $0.name == "page" })?
            .value
            .flatMap { Int($0) }
    }
}
