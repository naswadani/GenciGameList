//
//  DetailGameView.swift
//  GenciGameList
//
//  Created by naswakhansa on 24/08/25.
//

import SwiftUI

struct DetailGameView: View {
    @StateObject private var imgLoader = DataURLImageLoader()
    @StateObject var viewModel: DetailGameViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
                    .frame(width: 60, height: 60)
                    .padding(.top, 20)
            case .data:
                List {
                    LazyVStack(spacing: 10) {
                        if let imageData = viewModel.items?.backgroundImage, !imageData.isEmpty {
                            imageSection(url: URL(string: imageData))
                        }
                        LazyVStack(spacing: 5) {
                            Text(viewModel.items?.name ?? "")
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .fontDesign(.default)
                                .foregroundStyle(.primary)
                                .lineLimit(2)
                            LazyHStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.footnote)
                                    .foregroundStyle(.yellow)
                                Text(viewModel.items?.formattedRating ?? "")
                                    .font(.footnote)
                                    .fontDesign(.default)
                                    .foregroundStyle(.secondary)
                            }
                            
                            if let devs = viewModel.items?.developers, !devs.isEmpty {
                                Text(devs.map(\.name).joined(separator: ", "))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("-")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    Section("Genre") {
                        if let genres = viewModel.items?.genres, !genres.isEmpty {
                            Text(genres.map(\.name).joined(separator: ", "))
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("-")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Section("Description") {
                        Text(viewModel.items?.description ?? "")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                    
                    Section("Platfrom") {
                        if let names = viewModel.items?.platforms?.map({ $0.platform.name }), !names.isEmpty {
                            Text(names.joined(separator: " · "))
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        
                    }
                }
                .listSectionSpacing(0)
                .onChange(of: viewModel.items?.backgroundImage) {
                    Task { await imgLoader.load(viewModel.items?.backgroundImage) }
                }
            case .error(let error):
                ErrorView(message: error, retryAction: viewModel.fetchDetailGame)
            }
        }
        .onAppear {
            viewModel.fetchDetailGame()
        }
    }
    
    private func imageSection(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.gray.opacity(0.12)
                    ProgressView()
                }
            case .success(let image):
                image.resizable()
                    .scaledToFill()
            case .failure:
                ZStack {
                    Color.gray.opacity(0.12)
                    Image(systemName: "photo").foregroundStyle(.secondary)
                }
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 300, height: 250)
        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(alignment: .bottomTrailing, content: {
            if let metacritic = viewModel.items?.metacritic {
                Text("\(metacritic)")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundStyle(.primary)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.green)
                    )
                    .offset(x: -20, y: -20)
            }
        })
    }
}
