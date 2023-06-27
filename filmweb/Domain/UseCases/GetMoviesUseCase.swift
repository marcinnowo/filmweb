//
//  File.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Combine

protocol GetMoviesUseCase {
    func callAsFunction(page: Int) -> AnyPublisher<[Movie], Never>
}

class GetMoviesUseCaseImpl: GetMoviesUseCase {
    @Injected var repository: MoviesRepository

    init(repository: MoviesRepository) {
        self.repository = repository
    }

    init() {}

    func callAsFunction(page: Int) -> AnyPublisher<[Movie], Never> {
        repository.fetchMovies(page: page)
            .map {
                $0.compactMap { $0.toDomain() }
            }
            .catch { error -> Just<[Movie]> in
                print(error.localizedDescription)
                return Just([])
            }
            .eraseToAnyPublisher()
    }
}
