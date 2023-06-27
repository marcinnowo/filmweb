//
//  File.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 27/06/2023.
//

import Foundation

protocol SetAsFavoriteUseCase {
    func setIsFavorite(_ movie: Movie, isFavorite: Bool)
}

class SetAsFavoriteUseCaseImpl: SetAsFavoriteUseCase {
    @Injected var repository: MoviesRepository

    func setIsFavorite(_ movie: Movie, isFavorite: Bool) {
        if isFavorite {
            repository.save(movie: movie)
        } else {
            guard let movieDAO = repository.getMovies().first(where: { $0.title == movie.title && $0.info == movie.info }) else {
                return
            }

            repository.delete(movie: movieDAO)
        }
    }
}
