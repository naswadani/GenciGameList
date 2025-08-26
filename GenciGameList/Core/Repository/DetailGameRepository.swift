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
    func fetchDetailGame(gameId: Int, refresh: Bool) -> AnyPublisher<GameDetailResponseModel, AFError>}

final class DetailGameRepository: DetailGameRepositoryProtocol {
    private let dataSourceRemote: DetailGameDataSourceProtocol
    private let dataSourceLocal: DetailGameLocalDataSourceProtocol
    
    init(
        dataSourceRemote: DetailGameDataSourceProtocol,
        dataSourceLocal: DetailGameLocalDataSourceProtocol
    ) {
        self.dataSourceRemote = dataSourceRemote
        self.dataSourceLocal = dataSourceLocal
        
    }
    
    func fetchDetailGame(gameId: Int, refresh: Bool) -> AnyPublisher<GameDetailResponseModel, AFError> {
        let cachedPublisher: AnyPublisher<GameDetailResponseModel, AFError> = {
            guard !refresh, let cached = dataSourceLocal.getGameDetail(id: gameId) else {
                return Empty<GameDetailResponseModel, AFError>(completeImmediately: true)
                    .eraseToAnyPublisher()
            }
            let dto = GameMapper.fromRealm(cached)
            return Just(dto)
                .setFailureType(to: AFError.self)
                .eraseToAnyPublisher()
        }()
        
        let remotePublisher = dataSourceRemote.fetchDetailGame(gameId: gameId)
            .handleEvents(receiveOutput: { [weak self] dto in
                let obj = GameMapper.toRealm(dto)
                try? self?.dataSourceLocal.saveGameDetail(obj)
            })
            .eraseToAnyPublisher()
        
        if refresh {
            return remotePublisher
        } else {
            let remoteSafe = remotePublisher
                .append(remotePublisher)
                .eraseToAnyPublisher()
            
            return cachedPublisher
                .append(remoteSafe)
                .eraseToAnyPublisher()
        }
    }    
}
