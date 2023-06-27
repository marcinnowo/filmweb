//
//  File.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Foundation

extension URLRequest {
    mutating func addCredecials() {
        guard let path = Bundle.main.path(forResource: "API", ofType: "plist") else { return }
        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        guard let data = data,
              let plist = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: String],
              let key = plist["key"] else { return }

        addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        addValue("application/json", forHTTPHeaderField: "accept")
    }
}

extension URL {
    mutating func append(query: [URLQueryItem]) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        urlComponents.queryItems = query

        guard let url = urlComponents.url else { return }
        self = url
    }
}
