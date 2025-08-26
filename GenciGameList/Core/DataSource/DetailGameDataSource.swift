//
//  DetailGameDataSource.swift
//  GenciGameList
//
//  Created by naswakhansa on 25/08/25.
//

import Foundation
import Alamofire
import Combine

public protocol DetailGameDataSourceProtocol {
    func fetchDetailGame(gameId: Int) -> AnyPublisher<GameDetailResponseModel, AFError>
}

final class DetailGameDataSource: DetailGameDataSourceProtocol {
    init() {}
    
    func fetchDetailGame(gameId: Int) -> AnyPublisher<GameDetailResponseModel, AFError> {
        let endPoint = Endpoint.gameDetail(id: gameId)
        guard var components = URLComponents(
            url: APIConfig.baseURL.appendingPathComponent(endPoint.path),
            resolvingAgainstBaseURL: false
        ) else {
            return Fail(error: AFError.createURLRequestFailed(error: URLError(.badURL)))
                .eraseToAnyPublisher()
        }
        components.queryItems = endPoint.queryItems
        guard let url = components.url else {
            return Fail(error: AFError.createURLRequestFailed(error: URLError(.badURL)))
                .eraseToAnyPublisher()
        }
        return AF.request(url,method: .get)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: GameDetailResponseModel.self)
            .value()
            .eraseToAnyPublisher()
    }
}
