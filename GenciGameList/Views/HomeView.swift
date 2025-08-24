//
//  ProductListView.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            switch viewModel.state {
            case .idle:
                HStack {
                    Text("Hai")
                }
                .onAppear {
                    viewModel.fetchFirst()
                }
            case .loading:
                HStack {
                    Text("Loading")
                }
            case .data(_, _):
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.items) { game in
                        NavigationLink(destination: DetailGameView()) {
                            GameListItemView(game: game)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Divider()
                    }
                }
                .padding(.horizontal)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination:  SearchView(viewModel: SearchGamesViewModel(
                            repository: HomepageRepository(dataSource: HomepageDataSource())
                        ))) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20))
                        }
                    }
                }
            case .error(_):
                HStack {
                    Text("Loading")
                }
            }
        }
    }
}
