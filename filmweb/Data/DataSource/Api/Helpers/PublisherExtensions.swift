//
//  PublisherExtensions.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import Combine
import Foundation

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func decodeData<Value>() -> AnyPublisher<Value, Error> where Value: Decodable {
        return getRequestData()
            .decode(type: Value.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func getRequestData() -> AnyPublisher<Data, Error> {
        return tryMap {
            guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                throw APIError.wrongResponse
            }
            guard (200 ... 300).contains(code) else {
                throw APIError.httpCode(code)
            }
            return $0.0
        }
        .eraseToAnyPublisher()
    }
}
