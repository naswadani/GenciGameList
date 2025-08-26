//
//  ProductListView.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import SwiftUI
import AlertToast

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView(.vertical, showsIndicators: false) {
                switch viewModel.state {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                        .frame(width: 30, height: 30)
                case .data(let data):
                    LazyVStack(spacing: 10) {
                        dataDisplayList(data: data)
                        if viewModel.hasMore {
                            HStack(alignment: .center) {
                                Spacer()
                                if viewModel.isLoadingNext {
                                    ProgressView()
                                        .frame(width: 20, height: 20)
                                        .padding(.vertical, 8)
                                } else if viewModel.showRestartButton {
                                    Button(action: {
                                        viewModel.fetchNext()
                                    }) {
                                        Image(systemName: "arrow.trianglehead.counterclockwise")
                                            .foregroundStyle(.primary)
                                            .font(.subheadline)
                                            .padding(.top, 12)
                                            .padding(.bottom, 30)
                                    }
                                } else {
                                    Text("End List")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                        .padding(.vertical, 12)
                                }
                                Spacer()
                            }
                            .onAppear {
                                viewModel.fetchNext()
                            }
                        }
                    }
                case .error(let error):
                    ErrorView(message: error, retryAction: viewModel.restart)
                }
            }
        }
        .task {
            viewModel.loadIfNeeded()
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
        .toast(isPresenting: Binding(
            get: { viewModel.toastMessage != nil },
            set: { _ in viewModel.toastMessage = nil }
        )) {
            AlertToast(
                displayMode: .banner(.slide),
                type: .error(.red),
                title: viewModel.toastMessage
            )
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
    }
    
    private func dataDisplayList(data: [Game]) -> some View {
        ForEach(data, id: \.id) { game in
            NavigationLink(destination: DetailGameView(
                viewModel: DetailGameViewModel(
                    repository: DetailGameRepository(
                        dataSourceRemote: DetailGameDataSource(),
                        dataSourceLocal: DetailGameLocalDataSource()
                    ),gameID: game.id))
            ) {
                GameListItemView(game: game)
            }
            .buttonStyle(PlainButtonStyle())
            Divider()
        }
    }
}
