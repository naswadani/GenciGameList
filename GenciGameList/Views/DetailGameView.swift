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
            case .data, .refreshing:
                dataSection()
            case .error(let error):
                ErrorView(message: error, retryAction: viewModel.fetchDetailGame)
            }
        }
        .onAppear {
            viewModel.fetchDetailGame()
        }
        .refreshable {
            viewModel.refresh()
        }
    }
    
    private func dataSection() -> some View {
        List {
            LazyVStack(spacing: 10) {
                if let imageData = viewModel.item?.backgroundImage, !imageData.isEmpty {
                    imageSection(url: URL(string: imageData))
                }
                
                LazyVStack(spacing: 5) {
                    Text(viewModel.item?.name ?? "")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .fontDesign(.default)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.footnote)
                            .foregroundStyle(.yellow)
                        Text(viewModel.item?.formattedRating ?? "")
                            .font(.footnote)
                            .fontDesign(.default)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let devs = viewModel.item?.developers, !devs.isEmpty {
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
                if let genres = viewModel.item?.genres, !genres.isEmpty {
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
                Text(viewModel.item?.description ?? "")
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
            
            Section("Platform") {
                if let names = viewModel.item?.platforms?.map({ $0.platform.name }), !names.isEmpty {
                    Text(names.joined(separator: " · "))
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
        .listSectionSpacing(0)
        .onChange(of: viewModel.item?.backgroundImage ?? "") {
            Task { await imgLoader.load(viewModel.item?.backgroundImage) }
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
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                ZStack {
                    Color.gray.opacity(0.12)
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                }
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 300, height: 250)
        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(alignment: .bottomTrailing) {
            if let metacritic = viewModel.item?.metacritic {
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
        }
    }
}
