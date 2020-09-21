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

    let baseUrl = "https://sg666zbdmf.execute-api.us-east-1.amazonaws.com/dev"

    // MARK: Properties

    private var service: APIRequestService

    // MARK: Init

    init(service: APIRequestService = URLSessionAPIRequestService()) {
        self.service = service
    }

    // MARK: Fetching

    func fetch(at offset: Int) -> AnyPublisher<FactoryList, Error> {
        return service.publisher(for: baseUrl + "?offset=\(offset)")
            .map { $0.data }
            .decode(type: FactoryList.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
