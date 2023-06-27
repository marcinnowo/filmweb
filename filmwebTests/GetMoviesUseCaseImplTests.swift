//
//  File.swift
//  filmwebTests
//
//  Created by Marcin Nowowiejski on 26/06/2023.
//

import Combine
@testable import filmweb
import XCTest

class GetMoviesUseCaseImplTests: XCTestCase {
    var sut: GetMoviesUseCaseImpl!
    var mockRepository: MockMoviesRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockMoviesRepository()
        sut = GetMoviesUseCaseImpl(repository: mockRepository)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }

    func testGetMoviesSuccessfully() {
        // Given

        let movies: [MovieDTO] = [MovieDTO(adult: false,
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

                                  MovieDTO(adult: true,
                                           backdrop: "https://example.com/backdrop3.jpg",
                                           genreIds: [2, 3, 6],
                                           id: 789,
                                           language: "en",
                                           originalTitle: "Original Title 3",
                                           overview: "Movie 3 overview",
                                           popularity: 5.9,
                                           title: "Movie 3",
                                           posterPath: nil,
                                           releaseDate: "2022-11-30",
                                           video: false,
                                           voteAverage: 5.8,
                                           voteCount: 50)]
        mockRepository.stubbedFetchMoviesResult = Result.success(movies).publisher.eraseToAnyPublisher()

        // When
        var receivedMovies: [Movie] = []
        let expectation = self.expectation(description: "Movies received")

        sut(page: 1)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { movies in
                      receivedMovies = movies
                      expectation.fulfill()
                  })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)

        // Then
        XCTAssertTrue(mockRepository.invokedFetchMovies)
        XCTAssertEqual(mockRepository.invokedFetchMoviesCount, 1)
        XCTAssertEqual(receivedMovies.count, movies.count)
        XCTAssertEqual(receivedMovies[0].title, movies[0].title)
        XCTAssertEqual(receivedMovies[1].title, movies[1].title)
        XCTAssertEqual(receivedMovies[0].date, movies[0].releaseDate)
        XCTAssertEqual(receivedMovies[1].date, movies[1].releaseDate)
        XCTAssertEqual(receivedMovies[0].info, movies[0].overview)
        XCTAssertEqual(receivedMovies[1].info, movies[1].overview)
    }
}

class MockMoviesRepository: MoviesRepository {
    var invokedFetchMovies = false
    var invokedFetchMoviesCount = 0
    var invokedFetchMoviesParameters: (page: Int, Void)?
    var stubbedFetchMoviesResult: AnyPublisher<[MovieDTO], Error>!

    var invokedSearch = false
    var invokedSearchCount = 0
    var invokedSearchParameters: (text: String, Void)?
    var stubbedSearchResult: AnyPublisher<[MovieDTO], Error>!

    func fetchMovies(page: Int) -> AnyPublisher<[MovieDTO], Error> {
        invokedFetchMovies = true
        invokedFetchMoviesCount += 1
        invokedFetchMoviesParameters = (page, ())
        return stubbedFetchMoviesResult
    }

    func search(text: String) -> AnyPublisher<[MovieDTO], Error> {
        invokedSearch = true
        invokedSearchCount += 1
        invokedSearchParameters = (text, ())
        return stubbedSearchResult
    }

    func save(movie _: filmweb.Movie) {}

    func delete(movie _: filmweb.MovieDAO) {}

    func getMovies() -> [filmweb.MovieDAO] {
        []
    }
}
