//
//  DetailsRouter.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 26/06/2023.
//

import UIKit

protocol MovieDetailWireframeProtocol: AnyObject {}

class MovieDetailRouter: MovieDetailWireframeProtocol {
    weak var viewController: UIViewController?

    static func createModule(with movie: Movie) -> UIViewController {
        let view = MovieDetailView()
        let wireframe = MovieDetailRouter()

        let presenter = MovieDetailPresenter(view: view, wireframe: wireframe, movie: movie)

        view.presenter = presenter
        wireframe.viewController = view

        return view
    }
}
