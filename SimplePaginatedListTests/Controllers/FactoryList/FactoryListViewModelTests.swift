//
//  FactoryListViewModelTests.swift
//  SimplePaginatedListTests
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation
@testable import SimplePaginatedList
import XCTest

class FactoryListViewModelTests: XCTestCase {
    // MARK: Properties

    func test_WhenCreated_ThenRowsHaveOnlyPlaceholder() {
        // When
        let viewModel = FactoryListViewModel(repository: MockRepository())

        // Then
        XCTAssertTrue(containsOnlyPlaceholder(in: viewModel.rows))
    }

    private func containsOnlyPlaceholder(in rows: [FactoryListViewModel.Row]) -> Bool {
        return rows.allSatisfy { row in
            if case .placeholder = row {
                return true
            } else {
                return false
            }
        }
    }

    func test_GivenFactoryList_WhenDisplayingAnyIndex_ThenNumberOfRowEqualCount() {
        // Given
        let totalCount = 100
        let mockRepository = MockRepository()
        mockRepository.factoryListToReturn = FactoryList(count: totalCount)

        let viewModel = FactoryListViewModel(repository: mockRepository)

        // When
        viewModel.willDisplay(index: 0)

        // Then
        XCTAssertEqual(viewModel.rows.count, totalCount)
    }
}

extension FactoryListViewModelTests {
    class MockRepository: FactoryRepository {
        // MARK: Properties

        var factoryListToReturn = FactoryList()

        // MARK: Fetching

        func fetch(at offset: Int) -> AnyPublisher<FactoryList, Error> {
            return Just(factoryListToReturn)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
