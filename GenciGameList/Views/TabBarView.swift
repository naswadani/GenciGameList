//
//  TabBarView.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView(viewModel: HomeViewModel(
                    repository: HomepageRepository(dataSource: HomepageDataSource())
                ))
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.large)
            }
            .tag(0)
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationStack {
                SettingsView()
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tag(1)
            .tabItem {
                Label("Favorites", systemImage: "gear")
            }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    TabBarView()
}
