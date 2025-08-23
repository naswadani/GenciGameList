//
//  AppConfig.swift
//  GenciGameList
//
//  Created by naswakhansa on 24/08/25.
//


import Foundation

enum AppConfig {
    static var baseURL: URL {
        let raw = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? ""
        return URL(string: raw)!
    }
    static var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    }
}
