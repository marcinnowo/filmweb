//
//  SearchResultDTO.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Foundation

struct SearchResultDTO: Codable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
