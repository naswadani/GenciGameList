//
//  SearchGamesViewModel.swift
//  GenciGameList
//
//  Created by naswakhansa on 25/08/25.
//

import Foundation
import Combine

enum SearchViewState: Equatable {
    case idle
    case loading
    case data([Game])
    case error(String)
}

final class SearchGamesViewModel: ObservableObject {
    @Published private(set) var state: SearchViewState = .idle
    @Published private(set) var items: [Game] = []
    @Published var query: String = ""
    @Published var isLoadingNext: Bool = false
    @Published var toastMessage: String?
    @Published var hasMore = true
    @Published var showRestartButton = false
    
    private var bag = Set<AnyCancellable>()
    private let repository: HomepageRepositoryProtocol
    private var nextPage: String?
    
    init(repository: HomepageRepositoryProtocol) {
        self.repository = repository
    }
    
    func restart() {
        resetState()
        fetchFirst()
    }
    
    private func resetState() {
        bag.removeAll()
        
        items.removeAll()
        nextPage = nil
        isLoadingNext = false
        hasMore = true
        showRestartButton = false
        toastMessage = nil
        state = .idle
    }
    
    func fetchFirst() {
        let searchQuery = query.trimmingCharacters(in: .whitespaces)
        guard !searchQuery.isEmpty else { return }
        
        items.removeAll()
        nextPage = nil
        showRestartButton = false
        isLoadingNext = false
        state = .loading
        
        repository.fetch(.first(page: 1, search: searchQuery))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error.localizedDescription)
                    self.showRestartButton = true
                    self.hasMore = false
                }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                self.items = data.games
                self.nextPage = data.next
                self.state = .data(self.items)
                self.hasMore = (data.next != nil && !data.games.isEmpty)
                self.showRestartButton = false
            }
            .store(in: &bag)
    }
    
    func fetchNext() {
        guard let page = nextPage, hasMore, !isLoadingNext else { return }
        
        isLoadingNext = true
        showRestartButton = false
        
        repository.fetch(.next(url: page))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoadingNext = false
                
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.toastMessage = "Failed to load more results"
                    self.showRestartButton = true
                }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                self.items.append(contentsOf: data.games)
                self.nextPage = data.next
                self.hasMore = (data.next != nil && !data.games.isEmpty)
                self.state = .data(self.items)
                self.showRestartButton = false
            }
            .store(in: &bag)
    }
}
