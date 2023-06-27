//
//  File.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Foundation

enum APIError: Swift.Error, Equatable {
    case invalidURL
    case httpCode(Int)
    case wrongResponse
}
