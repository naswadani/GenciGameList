//
//  HomeViewModel.swift
//  GenciGameList
//
//  Created by naswakhansa on 24/08/25.
//

import Foundation
import Combine

enum HomeViewState: Equatable {
    case idle
    case loading
    case data([Game], next: String?)
    case error(String)
}

final class HomeViewModel: ObservableObject {
    private let repository: HomepageRepositoryProtocol
    private var bag = Set<AnyCancellable>()
    
    private(set) var currentSearch: String?
    
    
    @Published var viewState: HomeViewState = .idle
    @Published var games: [Game] = []
    @Published var isLoadingMore = false
    
    
    init(repository: HomepageRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchFirst(search: String? = nil) {
        currentSearch = search
        viewState = .loading
        games.removeAll()
        
        repository.fetch(.first(page: 1, search: search))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let error) = completion {
                    self.viewState = .error(error.localizedDescription)
                }
            } receiveValue : { [weak self] data in
                guard let self = self else { return }
                self.games = data.games
                self.viewState = .data(games, next: data.next)
            }
            .store(in: &bag)
    }
    
    func fetchNextIfNeeded() {
        guard case let .data(_, next) = viewState,
              let next, !isLoadingMore else { return }
        
        isLoadingMore = true
        repository.fetch(.next(url: next))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] c in
                self?.isLoadingMore = false
                if case .failure(let e) = c { self?.viewState = .error(e.localizedDescription) }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.games.append(contentsOf: data.games)
                self.viewState = .data(self.games, next: data.next)
            }
            .store(in: &bag)
    }
    
}
