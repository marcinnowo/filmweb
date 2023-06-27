//
//  File.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 27/06/2023.
//

import CoreData
import Foundation

protocol CoreDataService {
    func saveMovie(title: String, date: String, imageUrl: String?, info: String) -> MovieDAO?
    func getMovies() -> [MovieDAO]?
    func updateMovie(_ movie: MovieDAO) -> Bool
    func deleteMovie(_ movie: MovieDAO) -> Bool
}

class CoreDataServiceImpl: CoreDataService {
    private let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "DB")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    private func createMovieEntity() -> MovieDAO? {
        let context = persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "MovieDAO", in: context) else {
            return nil
        }

        return MovieDAO(entity: entityDescription, insertInto: context)
    }

    func saveMovie(title: String, date: String, imageUrl: String?, info: String) -> MovieDAO? {
        guard let movie = createMovieEntity() else {
            return nil
        }

        movie.title = title
        movie.date = date
        movie.imageUrl = imageUrl
        movie.info = info

        do {
            try persistentContainer.viewContext.save()
            return movie
        } catch {
            print("Failed to save movie: \(error)")
            return nil
        }
    }

    func getMovies() -> [MovieDAO]? {
        let fetchRequest: NSFetchRequest<MovieDAO> = MovieDAO.fetchRequest()

        do {
            let movies = try persistentContainer.viewContext.fetch(fetchRequest)
            return movies
        } catch {
            print("Failed to fetch movies: \(error)")
            return nil
        }
    }

    func updateMovie(_: MovieDAO) -> Bool {
        do {
            try persistentContainer.viewContext.save()
            return true
        } catch {
            print("Failed to update movie: \(error)")
            return false
        }
    }

    func deleteMovie(_ movie: MovieDAO) -> Bool {
        persistentContainer.viewContext.delete(movie)

        do {
            try persistentContainer.viewContext.save()
            return true
        } catch {
            print("Failed to delete movie: \(error)")
            return false
        }
    }
}
