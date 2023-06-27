//
//  File.swift
//  zad1
//
//  Created by Marcin Nowowiejski on 15/06/2023.
//

import CoreData

@objc(MovieDAO)

final class MovieDAO: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var date: String
    @NSManaged var imageUrl: String?
    @NSManaged var info: String

    class func fetchRequest() -> NSFetchRequest<MovieDAO> {
        return NSFetchRequest<MovieDAO>(entityName: "MovieDAO")
    }
}
