//
//  File.swift
//  filmwebTests
//
//  Created by Marcin Nowowiejski on 26/06/2023.
//

import Combine
@testable import filmweb
import XCTest

class SearchUseCaseImplTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    func testSearchMovies() {
        let mockMoviesRepository = MockMoviesRepository()
        let searchUseCase = SearchUseCaseImpl(repository: mockMoviesRepository)

        let searchText = "Action"
        let expectedMovies: [MovieDTO] = [
            MovieDTO(adult: false,
                     backdrop: "https://example.com/backdrop1.jpg",
                     genreIds: [1, 2, 3],
                     id: 123,
                     language: "en",
                     originalTitle: "Original Title 1",
                     overview: "Movie 1 overview",
                     popularity: 7.8,
                     title: "Movie 1",
                     posterPath: "https://example.com/poster1.jpg",
                     releaseDate: "2022-05-01",
                     video: false,
                     voteAverage: 6.4,
                     voteCount: 100),
            MovieDTO(adult: false,
                     backdrop: "https://example.com/backdrop2.jpg",
                     genreIds: [4, 5],
                     id: 456,
                     language: "en",
                     originalTitle: "Original Title 2",
                     overview: "Movie 2 overview",
                     popularity: 6.2,
                     title: "Movie 2",
                     posterPath: "https://example.com/poster2.jpg",
                     releaseDate: "2022-08-15",
                     video: true,
                     voteAverage: 7.1,
                     voteCount: 200),
        ]

        // Stub the search result in the mock repository
        mockMoviesRepository.stubbedSearchResult = Result.success(expectedMovies).publisher.eraseToAnyPublisher()

        // Set up the expectation
        let expectation = XCTestExpectation(description: "Search movies")

        // Execute the use case
        let publisher = searchUseCase(text: searchText)

        // Assert the results
        publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("Search movies failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { movies in
                XCTAssertEqual(movies, expectedMovies.map { $0.toDomain() })
            })
            .store(in: &cancellables)

        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
}
