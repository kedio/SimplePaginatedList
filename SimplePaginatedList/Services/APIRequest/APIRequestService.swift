//
//  APIRequestService.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation

protocol APIRequestService {
    typealias APIResponse = URLSession.DataTaskPublisher.Output
    func publisher(for urlString: String) -> AnyPublisher<APIResponse, URLError>
}

class DefaultAPIRequestService: APIRequestService {
    func publisher(for urlString: String) -> AnyPublisher<APIResponse, URLError> {
        guard let url = URL(string: urlString) else {
            return Result.Publisher(URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .eraseToAnyPublisher()
    }
}
