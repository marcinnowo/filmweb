//
//  ViewController.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 24/06/2023.
//

import UIKit

class MoviesViewController: UIViewController {
    var presenter: MoviesPresenterType!

    var tableView = UITableView()
    var searchBar: UISearchBar = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setup()
    }

    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.backgroundColor = .white
        setupTableView()
        setupSearchBar()
    }

    private func setupTableView() {
        tableView.delegate = self

        let cell = UINib(nibName: MovieCell.reuseIdentifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: MovieCell.reuseIdentifier)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    fileprivate func setup() {
        presenter.setDataSource(.init(
            tableView: tableView,
            cellProvider: { tableView, indexPath, model -> UITableViewCell? in
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell
                else { return UITableViewCell() }

                cell.setup(with: model)
                return cell
            }
        )
        )
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplay(indexPath: indexPath)
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selected(indexPath: indexPath)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange textSearched: String) {
        presenter.search(text: textSearched)
    }
}
