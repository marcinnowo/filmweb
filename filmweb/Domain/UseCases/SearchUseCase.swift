//
//  SearchUseCase.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Combine

protocol SearchUseCase {
    func callAsFunction(text: String) -> AnyPublisher<[Movie], Never>
}

class SearchUseCaseImpl: SearchUseCase {
    @Injected var repository: MoviesRepository

    init(repository: MoviesRepository) {
        self.repository = repository
    }

    init() {}

    func callAsFunction(text: String) -> AnyPublisher<[Movie], Never> {
        repository.search(text: text)
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
