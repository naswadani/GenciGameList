//
//  SearchView.swift
//  GenciGameList
//
//  Created by naswakhansa on 25/08/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchGamesViewModel
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 24) {
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
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style: .init())
                )
                
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.items) { game in
                        NavigationLink(destination: DetailGameView()) {
                            GameListItemView(game: game)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Divider()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
