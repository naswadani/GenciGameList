//
//  SearchView.swift
//  GenciGameList
//
//  Created by naswakhansa on 25/08/25.
//

import SwiftUI
import AlertToast

struct SearchView: View {
    @StateObject var viewModel: SearchGamesViewModel
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    TextField("Search", text: $viewModel.query)
                    Spacer()
                    Button(action: {
                        viewModel.fetchFirst()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.primary)
                    }
                    .disabled(viewModel.query.isEmpty)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    Capsule()
                        .strokeBorder(.primary, lineWidth: 1)
                )

                switch viewModel.state {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                        .frame(width: 30, height: 30)
                        .padding(.top, 20)
                case .data(let array):
                    LazyVStack(spacing: 24) {
                        LazyVStack(spacing: 10) {
                            ForEach(array) { game in
                                NavigationLink(destination: DetailGameView(
                                    viewModel: DetailGameViewModel(
                                        repository: DetailGameRepository(
                                            dataSource: DetailGameDataSource()
                                        ),gameID: game.id))
                                ) {
                                    GameListItemView(game: game)
                                }
                                .buttonStyle(PlainButtonStyle())
                                Divider()
                            }
                        }
                        if viewModel.hasMore {
                            HStack(alignment: .center) {
                                Spacer()
                                if viewModel.isLoadingNext {
                                    ProgressView()
                                        .frame(width: 15, height: 15)
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
                    .padding(.top, 20)
                    
                case .error(let error):
                    ErrorView(message: error, retryAction: viewModel.restart)
                        .padding(.top, 20)
                }
            }
        }
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
        .padding()
    }
}
