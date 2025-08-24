//
//  HomepageRepository.swift
//  GenciGameList
//
//  Created by naswakhansa on 24/08/25.
//

import Foundation
import Combine
import Alamofire

protocol HomepageRepositoryProtocol {
    func fetch(_ : GamesRequest) -> AnyPublisher<ListGamesResponseModel, AFError>
}

final class HomepageRepository: HomepageRepositoryProtocol {
    private let dataSource: HomepageDataSourceProtocol
    
    init(dataSource: HomepageDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetch(_ request: GamesRequest) -> AnyPublisher<ListGamesResponseModel, AFError> {
        return dataSource.fetch(request)
            .eraseToAnyPublisher()
    }
}
