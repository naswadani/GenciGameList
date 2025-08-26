//
//  SettingsRepository.swift
//  GenciGameList
//
//  Created by naswakhansa on 26/08/25.
//

import Foundation
import Combine

protocol SettingsRepositoryProtocol {
    func clearCache() -> AnyPublisher<Void, Never>
    func cacheSizeBytes() -> Int64
    func isDarkMode() -> Bool
    func setDarkMode(_ enabled: Bool)
}

final class SettingsRepository: SettingsRepositoryProtocol {
    private let dataSourceLocal: DetailGameLocalDataSourceProtocol
    private let key = "settings.darkmode.enabled"

    
    init(dataSourceLocal: DetailGameLocalDataSourceProtocol) {
        self.dataSourceLocal = dataSourceLocal
    }
    
    func clearCache() -> AnyPublisher<Void, Never> {
        Future { [dataSourceLocal] promise in
            try? dataSourceLocal.clearAllCache()
            URLCache.shared.removeAllCachedResponses()
            if let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
                if let files = try? FileManager.default.contentsOfDirectory(at: cachesURL, includingPropertiesForKeys: nil) {
                    for url in files { try? FileManager.default.removeItem(at: url) }
                }
            }
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func cacheSizeBytes() -> Int64 {
        var total: Int64 = 0
        let fm = FileManager.default
        
        if let realmURL = RealmFileLocator.defaultRealmURL() {
            let realmFiles = RealmFileLocator.relatedRealmFiles(for: realmURL)
            for url in realmFiles {
                if let size = (try? fm.attributesOfItem(atPath: url.path)[.size] as? NSNumber)?.int64Value {
                    total += size
                }
            }
        }
        
        total += Int64(URLCache.shared.currentDiskUsage)
        
        if let cachesURL = fm.urls(for: .cachesDirectory, in: .userDomainMask).first,
           let enumerator = fm.enumerator(at: cachesURL, includingPropertiesForKeys: [.fileSizeKey], options: [], errorHandler: nil) {
            for case let fileURL as URL in enumerator {
                let size = (try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize).map(Int64.init) ?? 0
                total += size
            }
        }
        
        return total
    }
    
    func isDarkMode() -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    func setDarkMode(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: key)
    }
}

private enum RealmFileLocator {
    static func defaultRealmURL() -> URL? {
        let doc = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return doc?.appendingPathComponent("default.realm")
    }
    
    static func relatedRealmFiles(for realmURL: URL) -> [URL] {
        return [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.deletingPathExtension().appendingPathExtension("log"),
            realmURL.deletingPathExtension().appendingPathExtension("log_a"),
            realmURL.deletingPathExtension().appendingPathExtension("log_b"),
            realmURL.deletingPathExtension().appendingPathExtension("management")
        ]
    }
}
