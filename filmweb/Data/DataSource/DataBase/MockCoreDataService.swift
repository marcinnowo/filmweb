//
//  MockCoreDataService.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 27/06/2023.
//

import Foundation

class MockCoreDataService: CoreDataService {
    func saveMovie(title _: String, date _: String, imageUrl _: String?, info _: String) -> MovieDAO? {
        nil
    }

    func getMovies() -> [MovieDAO]? {
        nil
    }

    func updateMovie(_: MovieDAO) -> Bool {
        true
    }

    func deleteMovie(_: MovieDAO) -> Bool {
        true
    }
}
