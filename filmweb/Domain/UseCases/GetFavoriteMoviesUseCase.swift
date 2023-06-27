//
//  GetFauvoriteMovies.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 27/06/2023.
//

import Foundation

protocol GetFavoriteMoviesUseCase {
    func callAsFunction() -> [Movie]
}

class GetFavoriteMoviesUseCaseImpl: GetFavoriteMoviesUseCase {
    @Injected var repository: MoviesRepository

    func callAsFunction() -> [Movie] {
        repository.getMovies().map {
            Movie(title: $0.title, date: $0.date, info: $0.info, poster: $0.imageUrl)
        }
    }
}
