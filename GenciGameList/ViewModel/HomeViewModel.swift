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
    @Published private(set) var state: HomeViewState = .idle
    @Published private(set) var items: [Game] = []

    private var bag = Set<AnyCancellable>()
    private var inFlight: AnyCancellable?
    
    private let repository: HomepageRepositoryProtocol
    private var nextPage: Int?
   
    init(repository: HomepageRepositoryProtocol) {
        self.repository = repository
    }

    func fetchFirst() {
        inFlight?.cancel()
        state = .loading
        items.removeAll()
        nextPage = nil

        inFlight = repository.fetch(.first(page: 1, search: nil))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cancellable in
                guard let self else { return }
                if case .failure(let error) = cancellable {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                self.items = data.games
                self.nextPage = data.next?.extractPageNumber()
                self.state = .data(self.items, next: data.next)
            }
    }

    func fetchNext() {
        guard let page = nextPage else { return }
        
        inFlight?.cancel()
        inFlight = repository.fetch(.first(page: page, search: nil))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] c in
                guard let self else { return }
                if case .failure(let e) = c { self.state = .error(e.localizedDescription) }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                self.items.append(contentsOf: data.games)
                self.nextPage = data.next?.extractPageNumber()
                self.state = .data(self.items, next: data.next)
            }
    }
}
