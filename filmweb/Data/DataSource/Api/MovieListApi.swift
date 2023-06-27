//
//  File.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 24/06/2023.
//

import Combine
import Foundation

protocol MovieListApi {
    func fetchMovies(page: Int) -> AnyPublisher<MovieListDTO, Error>
    func search(text: String) -> AnyPublisher<SearchResultDTO, Error>
}

class MovieListApiService: MovieListApi {
    enum Api: String {
        case movies = "https://api.themoviedb.org/3/movie/now_playing"
        case search = "https://api.themoviedb.org/3/search/movie"
    }

    enum QueryItems: String {
        case page
        case query
    }

    func fetchMovies(page: Int) -> AnyPublisher<MovieListDTO, Error> {
        guard var url = URL(string: Api.movies.rawValue) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        let qitem = URLQueryItem(name: QueryItems.page.rawValue, value: page.description)
        url.append(query: [qitem])

        var request = URLRequest(url: url)
        request.addCredecials()

        return URLSession.shared.dataTaskPublisher(for: request)
            .decodeData()
    }

    func search(text: String) -> AnyPublisher<SearchResultDTO, Error> {
        guard var url = URL(string: Api.search.rawValue) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        let qitem = URLQueryItem(name: QueryItems.query.rawValue, value: text)
        url.append(query: [qitem])

        var request = URLRequest(url: url)
        request.addCredecials()

        return URLSession.shared.dataTaskPublisher(for: request)
            .decodeData()
    }
}
