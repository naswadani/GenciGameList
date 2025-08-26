//
//  SettingsViewModel.swift
//  GenciGameList
//
//  Created by naswakhansa on 26/08/25.
//

import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    private let repository: SettingsRepositoryProtocol
    private var bag = Set<AnyCancellable>()
    
    @Published var isDarkMode: Bool = false
    @Published var cacheSizeText: String = "—"
    
    init(repository: SettingsRepositoryProtocol) {
        self.repository = repository
        self.isDarkMode = repository.isDarkMode()
        self.cacheSizeText = Self.formatBytes(repository.cacheSizeBytes())
    }
    
    func refreshCacheSize() {
        let bytes = repository.cacheSizeBytes()
        cacheSizeText = Self.formatBytes(bytes)
    }
    
    func clearCache() {
        repository.clearCache()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.refreshCacheSize()
            }
            .store(in: &bag)
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
        repository.setDarkMode(isDarkMode)
    }
    
    private static func formatBytes(_ bytes: Int64) -> String {
        let units = ["B","KB","MB","GB","TB"]
        var size = Double(bytes)
        var i = 0
        while size >= 1024 && i < units.count - 1 { size /= 1024; i += 1 }
        return String(format: "%.2f %@", size, units[i])
    }
}
