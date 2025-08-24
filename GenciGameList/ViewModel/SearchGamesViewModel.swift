//
//  SearchGamesViewModel.swift
//  GenciGameList
//
//  Created by naswakhansa on 25/08/25.
//

import Foundation
import Combine

final class SearchGamesViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var state: HomeViewState = .idle
    @Published private(set) var items: [Game] = []
    
    private let repository: HomepageRepositoryProtocol
    private var bag = Set<AnyCancellable>()
    private var nextPage: Int?
    private var inFlight: AnyCancellable?
    
    init(repository: HomepageRepositoryProtocol) { self.repository = repository }
    
    func fetchFirst() {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            state = .idle
            items.removeAll()
            nextPage = nil
            return
        }
        
        inFlight?.cancel()
        state = .loading
        items.removeAll()
        nextPage = 1
        
        inFlight = repository.fetch(.first(page: 1, search: query))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] c in
                guard let self else { return }
                if case .failure(let e) = c { self.state = .error(e.localizedDescription) }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                self.items = data.games
                self.nextPage = data.next?.extractPageNumber()
                self.state = .data(self.items, next: data.next)
            }
    }
    
    func fetchNext() {
        guard let page = nextPage,
              !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        inFlight?.cancel()
        inFlight = repository.fetch(.first(page: page, search: query))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cancellable in
                guard let self else { return }
                if case .failure(let error) = cancellable {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                self.items.append(contentsOf: data.games)
                self.nextPage = data.next?.extractPageNumber()
                self.state = .data(self.items, next: data.next)
            }
    }
}

