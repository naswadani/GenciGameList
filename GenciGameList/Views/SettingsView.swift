//
//  SettingsView.swift
//  GenciGameList
//
//  Created by naswakhansa on 23/08/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance: String = "light"
    @AppStorage("forceOffline") private var forceOffline: Bool = false

    @State private var cacheSize: String = "—"
    @State private var isOnline: Bool = true
    @State private var showingClearAlert = false

    var body: some View {
        List {
            Section("About") {
                LabeledContent("GenciGames", value: "v1.0")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text("GenciGames is a simple iOS application that showcases a list of popular games using the RAWG API. The app is built with SwiftUI following the MVVM architecture, and comes with search and offline access features for previously fetched data.")
                    .multilineTextAlignment(.leading)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Preferences") {
                Picker("Appearance", selection: $appearance) {
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(.segmented)
            }

            Section("Data & Offline") {
                Toggle("Force Offline Mode", isOn: $forceOffline)
                    .font(.footnote)
                    .foregroundStyle(.primary)
                
                Button(role: .destructive) {
                    showingClearAlert = true
                } label: {
                    Label("Clear Cache", systemImage: "trash")
                        .foregroundStyle(.primary)
                        .font(.footnote)
                }
                .alert("Clear Cache?", isPresented: $showingClearAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Clear", role: .destructive) {
                    }
                } message: {
                    Text("This removes locally cached data.")
                }
            }

            Section("Diagnostics") {
                LabeledContent("Network Status", value: isOnline ? "Online" : "Offline")
                    .font(.footnote)
                    .foregroundStyle(.primary)
                LabeledContent("Cache Size", value: cacheSize)
                    .font(.footnote)
                    .foregroundStyle(.primary)
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            isOnline = true
            cacheSize = "12.4 MB"
        }
    }
}

#Preview {
    SettingsView()
}
