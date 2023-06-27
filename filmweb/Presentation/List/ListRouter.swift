//
//  ListRouter.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import UIKit

protocol ListRouter: AnyObject {
    func showDetails(for movie: Movie)
}

class MoviesRouter: ListRouter {
    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = MoviesViewController()
        let presenter = MoviesPresenter()
        let router = MoviesRouter()

        router.viewController = view
        presenter.router = router

        view.presenter = presenter

        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }

    func showDetails(for movie: Movie) {
        let detailsModule = MovieDetailRouter.createModule(with: movie)
        viewController?.navigationController?.pushViewController(detailsModule, animated: true)
    }
}
