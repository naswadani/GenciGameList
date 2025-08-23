//
//  GameListItemView.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import SwiftUI

struct GameListItemView: View {
    var body: some View {
        HStack(alignment: .top) {
            Image("game")
                .resizable()
                .frame(maxWidth: 80)
                .frame(maxHeight: 60)
                .cornerRadius(10)
                .scaledToFit()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Borderland 4")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.default)
                    .foregroundStyle(.primary)
                
                Text("17-08-2029")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .fontDesign(.default)
                    .foregroundColor(.secondary)
                
                Text("Rockstar Games")
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
                Text("4.5/5")
                    .font(.footnote)
                    .fontDesign(.default)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    GameListItemView()
}
