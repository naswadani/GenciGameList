//
//  DetailGameViewModel.swift
//  GenciGameList
//
//  Created by naswakhansa on 25/08/25.
//

import Foundation
import Combine

enum GameDetailViewState: Equatable {
    case idle
    case loading
    case data
    case error(String)
}

final class DetailGameViewModel: ObservableObject {
    private let repository: DetailGameRepositoryProtocol
    private var inFlight: AnyCancellable?
    private var gameID: Int

    @Published private(set) var items: GameDetailResponseModel?
    @Published private(set) var state: GameDetailViewState = .idle
    
    init(repository: DetailGameRepositoryProtocol, gameID: Int) {
        self.repository = repository
        self.gameID = gameID
        self.items = nil
    }
    
    func fetchDetailGame() {
        state = .loading
        
        inFlight?.cancel()
        inFlight = repository.fetchDetailGame(gameId: gameID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure(let error) = completion {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                guard let self else { return }
                self.items = value
                self.state = .data
            }
    }
    
    deinit { inFlight?.cancel() }

}
