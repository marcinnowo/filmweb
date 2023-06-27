//
//  File.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Foundation

struct MovieDTO: Codable, Hashable {
    let adult: Bool
    let backdrop: String?
    let genreIds: [Int]
    let id: Int
    let language: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let title: String
    let posterPath: String?
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Double

    enum CodingKeys: String, CodingKey {
        case adult, id, overview, popularity, title, video
        case backdrop = "backdrop_path"
        case genreIds = "genre_ids"
        case language = "original_language"
        case posterPath = "poster_path"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    func toDomain() -> Movie {
        Movie(title: title, date: releaseDate, info: overview, poster: posterPath == nil ? nil : "https://image.tmdb.org/t/p/w500" + (posterPath ?? ""))
    }
}
