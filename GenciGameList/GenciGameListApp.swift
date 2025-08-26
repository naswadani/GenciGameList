//
//  GenciGameListApp.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import SwiftUI

@main
struct GenciGameListApp: App {
    @AppStorage("settings.darkmode.enabled") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            TabBarView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
