//
//  File.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Foundation

struct MovieListDTO: Codable {
    let dates: Dates
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int

    struct Dates: Codable {
        let maximum: String
        let minimum: String
    }

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
