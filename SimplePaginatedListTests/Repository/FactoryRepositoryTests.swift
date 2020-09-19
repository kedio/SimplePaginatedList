//
//  FactoryRepositoryTests.swift
//  SimplePaginatedListTests
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation
@testable import SimplePaginatedList
import XCTest

class FactoryRepositoryTests: XCTestCase {
    // MARK: Properties

    var request: AnyPublisher<FactoryList, Error>?

    // MARK: Test fetch and mapping

    func test_GivenOffset_WhenFetching_ThenFetchWithExpectedOffset() {
        // Given
        let mockRequestService = MockRequestService()
        let repository = DefaultFactoryRepository(requestService: mockRequestService)
        let offset = 10

        // When
        request = repository.fetch(at: offset)

        // Then
        let expectedUrl = repository.baseUrl + "?offset=10"
        XCTAssertTrue(mockRequestService.publisherCalled)
        XCTAssertEqual(mockRequestService.urlInPublisherCall, expectedUrl)
    }
}

extension FactoryRepositoryTests {
    class MockRequestService: APIRequestService {
        // MARK: Properties

        var publisherCalled = false
        var urlInPublisherCall: String?

        // MARK: Mocked methods

        func publisher(for urlString: String) -> AnyPublisher<APIResponse, URLError> {
            publisherCalled = true
            urlInPublisherCall = urlString
            return Result.failure(URLError(.cancelled)).publisher.eraseToAnyPublisher()
        }
    }
}
