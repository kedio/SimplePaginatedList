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

    var viewModel: FactoryListViewModel!
    var mockRepository: MockRepository!

    // MARK: SetUp

    override func setUp() {
        mockRepository = MockRepository()
        viewModel = FactoryListViewModel(repository: mockRepository)
    }

    func test_WhenCreated_ThenRowsHaveOnlyPlaceholder() {
        // Then
        XCTAssertTrue(containsOnlyPlaceholder(in: viewModel.rows))
    }

    func test_WhenDisplayFirstIndex_ThenFetchExpectedOffset() {
        // When
        viewModel.willDisplayRow(at: 0)
        // Then
        XCTAssertEqual(mockRepository.offsetInFetchCall, 0)
    }

    func test_WhenDisplayIndexInFirstPage_ThenFetchExpectedOffset() {
        // When
        viewModel.willDisplayRow(at: 3)
        // Then
        XCTAssertEqual(mockRepository.offsetInFetchCall, 0)
    }

    func test_WhenDisplayFirstIndexInSecondPage_ThenFetchExpectedOffset() {
        // When
        viewModel.willDisplayRow(at: 10)
        // Then
        XCTAssertEqual(mockRepository.offsetInFetchCall, 10)
    }

    func test_WhenDisplayIndexInSecondPage_ThenFetchExpectedOffset() {
        // When
        viewModel.willDisplayRow(at: 18)
        // Then
        XCTAssertEqual(mockRepository.offsetInFetchCall, 10)
    }

    func test_WhenDisplayIndexInSamePage_ThenFetchIsNotCalledTwice() {
        // When
        viewModel.willDisplayRow(at: 0)
        viewModel.willDisplayRow(at: 6)

        // Then
        XCTAssertEqual(mockRepository.timeCalled, 1)
    }

    func test_GivenFailureForPage_WhenDisplayIndexInFailedPage_ThenFetchIsCalledAgain() {
        // Given
        mockRepository.errorToReturnByOffset[10] = URLError(.cancelled)

        // When
        viewModel.willDisplayRow(at: 10)
        viewModel.willDisplayRow(at: 14)

        // Then
        XCTAssertEqual(mockRepository.timeCalled, 2)
    }

    func test_GivenTotalCount_WhenDisplayingAnyIndex_ThenNumberOfRowEqualTotal() {
        // Given
        let totalCount = 100
        let index = 0
        mockRepository.factoryListToReturnByOffset[index] = FactoryList(count: totalCount)

        // When
        viewModel.willDisplayRow(at: index)

        // Then
        XCTAssertEqual(viewModel.rows.count, totalCount)
    }

    func test_GivenFirstPage_WhenDisplayingFirstIndex_ThenHasFactoryRows() {
        // Given
        let factories = (0 ..< 10).map { Factory(id: $0) }
        let firstPage = FactoryList(count: 50, next: nil, previous: nil, results: factories)
        let index = 0
        mockRepository.factoryListToReturnByOffset[index] = firstPage

        // When
        viewModel.willDisplayRow(at: index)

        // Then
        XCTAssertTrue(hasExpectedRowsForFirstIndex(in: viewModel.rows))
    }

    private func hasExpectedRowsForFirstIndex(in rows: [FactoryListViewModel.Row]) -> Bool {
        let firstPage = Array(rows[0 ..< 10])
        let rest = Array(rows[10...])
        return containsOnlyFactoryRow(in: firstPage) && containsOnlyPlaceholder(in: rest)
    }

    func test_GivenAnyPage_WhenDisplayingIndexInPage_ThenHasFactoryRows() {
        // Given
        let factories = (0 ..< 10).map { Factory(id: $0) }
        let factoryList = FactoryList(count: 50, next: nil, previous: nil, results: factories)
        let index = 10
        mockRepository.factoryListToReturnByOffset[index] = factoryList

        // When
        viewModel.willDisplayRow(at: index)

        // Then
        XCTAssertTrue(hasExpectedRowsForOtherIndex(in: viewModel.rows))
    }

    private func hasExpectedRowsForOtherIndex(in rows: [FactoryListViewModel.Row]) -> Bool {
        let firstPage = Array(rows[0 ..< 10])
        print(firstPage)
        let otherPage = Array(rows[10 ..< 20])
        print(otherPage)
        let rest = Array(rows[20...])
        print(rest)
        return containsOnlyPlaceholder(in: firstPage)
            && containsOnlyFactoryRow(in: otherPage)
            && containsOnlyPlaceholder(in: rest)
    }

    func test_GivenTwoPage_WhenDisplayingIndexInPages_ThenHasFactoryRows() {
        // Given
        let factories = (0 ..< 10).map { Factory(id: $0) }

        let firstFactoryList = FactoryList(count: 50, next: nil, previous: nil, results: factories)
        let firstIndex = 0
        mockRepository.factoryListToReturnByOffset[firstIndex] = firstFactoryList

        let secondFactoryList = FactoryList(count: 50, next: nil, previous: nil, results: factories)
        let secondIndex = 20
        mockRepository.factoryListToReturnByOffset[secondIndex] = secondFactoryList

        // When
        viewModel.willDisplayRow(at: firstIndex)
        viewModel.willDisplayRow(at: secondIndex)

        // Then
        XCTAssertTrue(hasExpectedRowsForMultiplePages(in: viewModel.rows))
    }

    private func hasExpectedRowsForMultiplePages(in rows: [FactoryListViewModel.Row]) -> Bool {
        let firstPage = Array(rows[0 ..< 10])
        let placeHolders = Array(rows[10 ..< 20])
        let secondPage = Array(rows[20 ..< 30])
        let rest = Array(rows[30...])
        return containsOnlyFactoryRow(in: firstPage)
            && containsOnlyPlaceholder(in: placeHolders)
            && containsOnlyFactoryRow(in: secondPage)
            && containsOnlyPlaceholder(in: rest)
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

    private func containsOnlyFactoryRow(in rows: [FactoryListViewModel.Row]) -> Bool {
        return rows.allSatisfy { row in
            if case .factory = row {
                return true
            } else {
                return false
            }
        }
    }
}

extension FactoryListViewModelTests {
    class MockRepository: FactoryRepository {
        // MARK: Properties

        var factoryListToReturnByOffset: [Int: FactoryList] = [:]
        var errorToReturnByOffset: [Int: URLError] = [:]
        var offsetInFetchCall: Int?
        var timeCalled = 0

        // MARK: Fetching

        func fetch(at offset: Int) -> AnyPublisher<FactoryList, Error> {
            let factoryList = factoryListToReturnByOffset[offset] ?? FactoryList()
            let error = errorToReturnByOffset[offset]

            offsetInFetchCall = offset
            timeCalled += 1

            if let error = error {
                return Result.Publisher(error)
                    .eraseToAnyPublisher()
            } else {
                return Just(factoryList)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }
    }
}
