//
//  DetailGameRepository.swift
//  GenciGameList
//
//  Created by naswakhansa on 25/08/25.
//

import Foundation
import Combine
import Alamofire

public protocol DetailGameRepositoryProtocol {
    func fetchDetailGame(gameId: Int) -> AnyPublisher<GameDetailResponseModel, AFError>
}

final class DetailGameRepository: DetailGameRepositoryProtocol {
    private let dataSource: DetailGameDataSourceProtocol
    
    init(dataSource: DetailGameDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchDetailGame(gameId: Int) -> AnyPublisher<GameDetailResponseModel, AFError> {
        dataSource.fetchDetailGame(gameId: gameId)
            .eraseToAnyPublisher()
    }
}
