//
//  SettingsView.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @State private var showingClearAlert = false
    @Binding var selectedTab: AppTab
    
    init(viewModel: SettingsViewModel, selectedTab: Binding<AppTab>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _selectedTab = selectedTab
    }
    
    var body: some View {
        List {
            Section("About") {
                Text("GenciGames")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("GenciGames is a simple iOS application that showcases a list of popular games using the RAWG API. The app is built with SwiftUI following the MVVM architecture, and comes with search and offline access features for previously fetched data.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section("Preferences") {
                Toggle("Dark Mode", isOn: $viewModel.isDarkMode)
                    .font(.footnote)
                    .onChange(of: viewModel.isDarkMode) {
                        viewModel.toggleDarkMode()
                    }
            }
            
            Section("Data") {
                Button(role: .destructive) {
                    showingClearAlert = true
                } label: {
                    Label("Clear Cache", systemImage: "trash")
                        .font(.footnote)
                }
                .alert("Clear Cache?", isPresented: $showingClearAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Clear", role: .destructive) {
                        viewModel.clearCache()
                    }
                } message: {
                    Text("This removes locally cached data.")
                }
                LabeledContent("Cache Size", value: viewModel.cacheSizeText)
                    .font(.footnote)
            }
            
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.refreshCacheSize()
        }
        .onChange(of: selectedTab) {
            if selectedTab == .settings {
                viewModel.refreshCacheSize()
            }
        }
    }
}
