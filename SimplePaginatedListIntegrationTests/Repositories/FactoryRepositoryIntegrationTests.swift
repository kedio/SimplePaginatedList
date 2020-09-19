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
    
    var request: Cancellable?

    // MARK: Test fetch and mapping
    
    func test_GivenRepository_WhenFetching_ThenReceiveMappedData() {
        // Given
        let expected = expectation(description: "Fetch should complete")
        let repository = DefaultFactoryRepository()
        var receivedFactoryList: FactoryList?

        // When
        request = repository.fetch(at: 0)
            .sink(receiveCompletion: { _ in
                expected.fulfill()
            }, receiveValue: { list in
                receivedFactoryList = list
            })

        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(receivedFactoryList)
    }
}
