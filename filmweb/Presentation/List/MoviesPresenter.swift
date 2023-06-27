//
//  MoviesPresenter.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Combine
import UIKit

enum Section: Hashable {
    case main
}

protocol MoviesPresenterType {
    typealias DataSource = UITableViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>

    // init(dataSource: DataSource)
    func setDataSource(_: DataSource)
    func selected(indexPath: IndexPath)
    func willDisplay(indexPath: IndexPath)
    func search(text: String)
}

class MoviesPresenter: MoviesPresenterType {
    @Injected var getMoviesUseCase: GetMoviesUseCase
    @Injected var searchUseCase: SearchUseCase
    @Injected var getFavoritesUseCase: GetFavoriteMoviesUseCase

    var router: ListRouter!
    var diffableDataSource: DataSource!
    var snapshot: Snapshot

    var movies = [Movie]()

    @Published var keyWord: String = ""
    @Published var page: Int = 1

    private var cancellables = Set<AnyCancellable>()

    required init() {
        snapshot = Snapshot()
        snapshot.appendSections([.main])
        movies.append(contentsOf: getFavoritesUseCase())
        bind()
    }

    func setDataSource(_ source: DataSource) {
        diffableDataSource = source
    }

    func selected(indexPath: IndexPath) {
        guard indexPath.row < movies.count else { return }
        router.showDetails(for: movies[indexPath.row])
    }

    func willDisplay(indexPath: IndexPath) {
        if diffableDataSource.snapshot().numberOfSections - 1 == indexPath.section {
            let currentSection = diffableDataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
            if diffableDataSource.snapshot()
                .numberOfItems(inSection: currentSection) - 1 == indexPath.row,
                currentSection == .main
            {
                page += 1
            }
        }
    }

    func search(text: String) {
        keyWord = text
    }

    func bind() {
        $page
            .flatMap { [weak self] page -> AnyPublisher<[Movie], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                return getMoviesUseCase(page: page)
            }
            .sink { [weak self] in
                guard let self else { return }
                let removeSet = Set(movies)
                movies.append(contentsOf: $0.filter { !removeSet.contains($0) })
                snapshot.appendItems($0, toSection: .main)
                diffableDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)

        $keyWord.receive(on: RunLoop.main).debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .flatMap { [weak self] text -> AnyPublisher<[Movie], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                if text.count > 2 {
                    return searchUseCase(text: text)
                } else {
                    return Just(movies).eraseToAnyPublisher()
                }
            }
            .sink { [weak self] searchResult in
                guard let self else { return }
                snapshot.deleteAllItems()
                snapshot.appendSections([.main])
                snapshot.appendItems(searchResult)
                diffableDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
}
