//
//  AppConfig.swift
//  GenciGameList
//
//  Created by naswakhansa on 24/08/25.
//


import Foundation

enum APIConfig {
    static var baseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
              let url = URL(string: urlString) else {
            fatalError("API_BASE_URL not found in Info.plist")
        }
        return url
    }
    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY not found di Info in.plist")
        }
        return key
    }
}
