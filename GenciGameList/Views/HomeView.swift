//
//  ProductListView.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import SwiftUI

struct HomeView: View {
    @State private var username: String = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 24) {
                HStack {
                    TextField("Search", text: $username)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style: .init())
                )
                
                LazyVStack(spacing: 10) {
                    ForEach(0..<20, id: \.self) { index in
                        NavigationLink(destination: DetailGameView()) {
                            GameListItemView()
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

#Preview {
    HomeView()
}
