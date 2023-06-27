//
//  filmwebTests.swift
//  filmwebTests
//
//  Created by Marcin Nowowiejski on 26/06/2023.
//

import Combine
@testable import filmweb
import XCTest

class MovieListApiServiceTests: XCTestCase {
    var apiService: MovieListApiService!

    override func setUp() {
        super.setUp()
        apiService = MovieListApiService()
    }

    override func tearDown() {
        apiService = nil
        super.tearDown()
    }

    func testFetchMovies() {
        let page = 1
        let expectation = XCTestExpectation(description: "Fetch movies")

        let cancellable = apiService.fetchMovies(page: page)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTFail("Failed to fetch movies: \(error)")
                }
            }, receiveValue: { _ in
                // Perform assertions on the movieListDTO if needed
            })

        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }

    func testSearch() {
        let searchText = "Avengers"
        let expectation = XCTestExpectation(description: "Search movies")

        let cancellable = apiService.search(text: searchText)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTFail("Failed to search movies: \(error)")
                }
            }, receiveValue: { _ in
                // Perform assertions on the searchResultDTO if needed
            })

        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
}
