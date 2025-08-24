//
//  DataURLImageLoader.swift
//  GenciGameList
//
//  Created by naswakhansa on 25/08/25.
//


import Foundation

@MainActor
final class DataURLImageLoader: ObservableObject {
    @Published var dataURL: URL?

    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()

    func load(_ urlString: String?) async {
        guard let string = urlString, let url = URL(string: string) else {
            dataURL = nil; return
        }
        do {
            let (data, response) = try await session.data(from: url)
            let mime = (response as? HTTPURLResponse)?.mimeType ?? "image/jpeg"
            let base64 = data.base64EncodedString()
            dataURL = URL(string: "data:\(mime);base64,\(base64)")
        } catch {
            dataURL = nil
        }
    }
}
