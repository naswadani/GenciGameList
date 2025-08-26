//
//  TabBarView.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import SwiftUI

enum AppTab: Hashable { case home, settings }

struct TabBarView: View {
    @State private var selection: AppTab = .home

    @StateObject private var homeVM = HomeViewModel(
        repository: HomepageRepository(dataSource: HomepageDataSource())
    )
    @StateObject private var settingsVM = SettingsViewModel(
        repository: SettingsRepository(dataSourceLocal: DetailGameLocalDataSource())
    )

    var body: some View {
        TabView(selection: $selection) {

            NavigationStack {
                HomeView(viewModel: homeVM)
            }
            .tag(AppTab.home)
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack {
                SettingsView(viewModel: settingsVM, selectedTab: $selection)
            }
            .tag(AppTab.settings)
            .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}
