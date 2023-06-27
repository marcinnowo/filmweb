//
//  MoviesRepository.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Combine

protocol MoviesRepository {
    func fetchMovies(page: Int) -> AnyPublisher<[MovieDTO], Error>
    func search(text: String) -> AnyPublisher<[MovieDTO], Error>

    func save(movie: Movie)

    func delete(movie: MovieDAO)
    func getMovies() -> [MovieDAO]
}
