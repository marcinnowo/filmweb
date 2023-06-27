//
//  File.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Combine

class MoviesRepositoryImpl: MoviesRepository {
    @Injected var api: MovieListApi
    @Injected var dataBase: CoreDataService

    init(api: MovieListApi) {
        self.api = api
    }

    init() {}

    func fetchMovies(page: Int) -> AnyPublisher<[MovieDTO], Error> {
        api.fetchMovies(page: page)
            .map {
                $0.results
            }
            .eraseToAnyPublisher()
    }

    func search(text: String) -> AnyPublisher<[MovieDTO], Error> {
        api.search(text: text)
            .map {
                $0.results
            }
            .eraseToAnyPublisher()
    }

    func save(movie: Movie) {
        dataBase.saveMovie(title: movie.title, date: movie.date, imageUrl: movie.poster, info: movie.info)
    }

    func delete(movie: MovieDAO) {
        dataBase.deleteMovie(movie)
    }

    func getMovies() -> [MovieDAO] {
        dataBase.getMovies() ?? []
    }
}
