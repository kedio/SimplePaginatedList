//
//  FactoryRepositoryIntegrationTests.swift
//  SimplePaginatedListIntegrationTests
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation
@testable import SimplePaginatedList
import XCTest

class FactoryRepositoryIntegrationTests: XCTestCase {
    // MARK: Properties

    var cancelBag = Set<AnyCancellable>()

    // MARK: Test fetch

    func test_GivenRepository_WhenFetching_ThenReceiveMappedData() {
        // Given
        let expected = expectation(description: "Fetch should complete")
        let repository = DefaultFactoryRepository()

        // When
        var receivedFactoryList: FactoryList?
        repository.fetch(at: 0)
            .sink(receiveCompletion: { _ in
                expected.fulfill()
            }, receiveValue: { list in
                receivedFactoryList = list
            })
            .store(in: &cancelBag)

        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(receivedFactoryList)
    }
}
