//
//  File.swift
//  filmwebTests
//
//  Created by Marcin Nowowiejski on 26/06/2023.
//

import Combine
@testable import filmweb
import XCTest

class MoviesRepositoryImplTests: XCTestCase {
    var sut: MoviesRepositoryImpl!
    var apiService: MockMovieListApiService!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        Container.registerMockDependecies()
        apiService = MockMovieListApiService()
        sut = MoviesRepositoryImpl(api: apiService)
    }

    override func tearDown() {
        sut = nil
        apiService = nil
        cancellables.removeAll()
        Dependency.shared.clear()
        super.tearDown()
    }

    // MARK: - Tests

    func testFetchMovies_Success() {
        // Given
        let expectedMovies: [Movie] = [
            Movie(title: "Movie 1", date: "2023-06-26", info: "Movie 1 overview", poster: nil),
            Movie(title: "Movie 2", date: "2023-06-27", info: "Movie 2 overview", poster: nil),
        ]
        let movieListDTO = createMovieListDTO(with: expectedMovies)
        let page = 1

        apiService.stubbedFetchMoviesResult = Result<MovieListDTO, any Error>.success(movieListDTO)

        // When
        let expectation = XCTestExpectation(description: "Fetch movies")
        var receivedMovies: [Movie] = []

        sut.fetchMovies(page: page)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTFail("Fetching movies failed with error: \(error)")
                }
            } receiveValue: { movies in
                receivedMovies = movies.map { $0.toDomain() }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)

        // Then
        XCTAssertEqual(receivedMovies, expectedMovies, "Fetched movies do not match the expected movies")
        XCTAssertEqual(apiService.invokedFetchMoviesPage, page, "API service was not called with the correct page")
    }

    func testFetchMovies_Failure() {
        // Given
        let expectedError = APIError.invalidURL
        let page = 1

        apiService.stubbedFetchMoviesResult = Result<MovieListDTO, Error>.failure(expectedError)

        // When
        let expectation = XCTestExpectation(description: "Fetch movies")
        var receivedError: Error?

        sut.fetchMovies(page: page)
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Fetching movies should have failed")
                case let .failure(error):
                    receivedError = error
                    expectation.fulfill()
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(receivedError, "Did not receive an error while fetching movies")
        XCTAssertEqual(receivedError as? APIError, expectedError, "Received error does not match the expected error")
        XCTAssertEqual(apiService.invokedFetchMoviesPage, page, "API service was not called with the correct page")
    }

    // Helper method to create a MovieListDTO from an array of Movie objects
    private func createMovieListDTO(with movies: [Movie]) -> MovieListDTO {
        return MovieListDTO(
            dates: MovieListDTO.Dates(maximum: "2023-06-30", minimum: "2023-06-01"),
            page: 1,
            results: movies.map { $0.toDTO() },
            totalPages: 1,
            totalResults: movies.count
        )
    }
}

// Mock implementation of MovieListApiService for testing purposes
class MockMovieListApiService: MovieListApi {
    var invokedFetchMoviesPage: Int?
    var stubbedFetchMoviesResult: Result<MovieListDTO, Error>!

    func fetchMovies(page: Int) -> AnyPublisher<MovieListDTO, Error> {
        invokedFetchMoviesPage = page
        return stubbedFetchMoviesResult.publisher.eraseToAnyPublisher()
    }

    func search(text _: String) -> AnyPublisher<SearchResultDTO, Error> {
        fatalError("Not implemented")
    }
}

// Helper method to convert a Movie object to MovieDTO
extension Movie {
    func toDTO() -> MovieDTO {
        return MovieDTO(
            adult: false,
            backdrop: nil,
            genreIds: [],
            id: 0,
            language: "en",
            originalTitle: title,
            overview: info,
            popularity: 0.0,
            title: title,
            posterPath: nil,
            releaseDate: date,
            video: false,
            voteAverage: 0.0,
            voteCount: 0.0
        )
    }
}
