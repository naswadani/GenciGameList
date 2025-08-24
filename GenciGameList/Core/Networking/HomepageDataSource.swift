//
//  HomepageDataSource.swift
//  GenciGameList
//
//  Created by naswakhansa on 24/08/25.
//

import Alamofire
import Combine
import Foundation


public protocol HomepageDataSourceProtocol {
    func fetch(_ request: GamesRequest) -> AnyPublisher<ListGamesResponseModel, AFError>
}

final class HomepageDataSource: HomepageDataSourceProtocol {
    init(){}
    
    func fetch(_ request: GamesRequest) -> AnyPublisher<ListGamesResponseModel, AFError> {
        let url: URL
        
        switch request {
        case .first(let page, let search):
            let endPoint = Endpoint.games(page: page, search: search)
            guard var components = URLComponents(
                url: APIConfig.baseURL.appendingPathComponent(endPoint.path),
                resolvingAgainstBaseURL: false
            ) else {
                return Fail(error: AFError.createURLRequestFailed(error: URLError(.badURL)))
                    .eraseToAnyPublisher()
            }
            components.queryItems = endPoint.queryItems
            guard let built = components.url else {
                return Fail(error: AFError.createURLRequestFailed(error: URLError(.badURL)))
                    .eraseToAnyPublisher()
            }
            url = built
        case .next(let urlString):
            guard let urlAbsolute = URL(string: urlString) else {
                return Fail(error: AFError.createURLRequestFailed(error: URLError(.badURL)))
                              .eraseToAnyPublisher()
            }
            url = urlAbsolute
        }
        
        return AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: ListGamesResponseModel.self)
            .value()
            .eraseToAnyPublisher()
    }
}
