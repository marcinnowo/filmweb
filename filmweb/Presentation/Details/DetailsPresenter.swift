//
//  DetailsPresenter.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Foundation

protocol MovieDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func changeFavouriteState()
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    weak var view: MovieDetailViewProtocol?
    var wireframe: MovieDetailWireframeProtocol
    var movie: Movie
    var isFavorite: Bool = false

    @Injected private var setFavoritesUseCase: SetAsFavoriteUseCase
    @Injected private var getFavoritesUseCase: GetFavoriteMoviesUseCase

    init(view: MovieDetailViewProtocol, wireframe: MovieDetailWireframeProtocol, movie: Movie) {
        self.view = view
        self.wireframe = wireframe
        self.movie = movie
    }

    func viewDidLoad() {
        view?.showMovieDetail(movie)
        isFavorite = getFavoritesUseCase().contains(where: { $0.info == movie.info && $0.title == movie.title })
        view?.likeButtonState(filled: isFavorite)
    }

    func changeFavouriteState() {
        isFavorite.toggle()
        setFavoritesUseCase.setIsFavorite(movie, isFavorite: isFavorite)
        view?.likeButtonState(filled: isFavorite)
    }
}
