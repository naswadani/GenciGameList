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
    case refreshing
    case error(String)
}

@MainActor
final class DetailGameViewModel: ObservableObject {
    private let repository: DetailGameRepositoryProtocol
    private var inFlight: AnyCancellable?
    private let gameID: Int
    
    @Published private(set) var item: GameDetailResponseModel?
    @Published private(set) var state: GameDetailViewState = .idle
    
    init(repository: DetailGameRepositoryProtocol, gameID: Int) {
        self.repository = repository
        self.gameID = gameID
    }
    
    func fetchDetailGame() {
        state = .loading
        subscribe(refresh: false)
    }
    
    func refresh() {
        if item != nil { state = .refreshing } else { state = .loading }
        subscribe(refresh: true)
    }
    
    private func subscribe(refresh: Bool) {        
        inFlight?.cancel()
        inFlight = repository.fetchDetailGame(gameId: gameID, refresh: refresh)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    if self.item != nil { self.state = .data }
                case .failure(let err):
                    if self.item == nil {
                        self.state = .error(err.localizedDescription)
                    } else {
                        self.state = .data
                    }
                }
            } receiveValue: { [weak self] value in
                guard let self else { return }
                self.item = value
                self.state = .data
            }
    }
    deinit { inFlight?.cancel() }
}
