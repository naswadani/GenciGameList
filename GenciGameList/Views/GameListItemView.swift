//
//  GameListItemView.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import SwiftUI

struct GameListItemView: View {
    @StateObject private var imgLoader = DataURLImageLoader()
    let game: Game
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: imgLoader.dataURL) { phase in
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
            .frame(width: 80, height: 60)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .task { await imgLoader.load(game.backgroundImage) }
            
            
            VStack(alignment: .leading, spacing: 5) {
                Text(game.name ?? "")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.default)
                    .foregroundStyle(.primary)
                
                Text(game.released ?? "")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .fontDesign(.default)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .font(.footnote)
                    .foregroundStyle(.yellow)
                Text("\(game.formattedRating)/5")
                    .font(.footnote)
                    .fontDesign(.default)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
