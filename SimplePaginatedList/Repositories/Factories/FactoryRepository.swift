//
//  FactoryRepository.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation

protocol FactoryRepository {
    func fetch(at offset: Int) -> AnyPublisher<FactoryList, Error>
}

class DefaultFactoryRepository: FactoryRepository {
    // MARK: Constants
    
    private let baseUrl = "https://sg666zbdmf.execute-api.us-east-1.amazonaws.com/dev"

    // MARK: Fetching
    
    func fetch(at offset: Int) -> AnyPublisher<FactoryList, Error> {
        guard let url = URL(string: baseUrl) else {
            return Fail(error: ErrorType.unexpected).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FactoryList.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

extension DefaultFactoryRepository {
    enum ErrorType: String, Error {
        case unexpected
    }
}
