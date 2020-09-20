//
//  FactoryDetailsViewModelTests.swift
//  SimplePaginatedListTests
//
//  Created by Kevin Dion on 2020-09-20.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation
@testable import SimplePaginatedList
import XCTest

class FactoryDetailsViewModelTests: XCTestCase {
    func test_GivenDivision_WhenCreated_AppendPrefix() {
        // Given
        let factory = Factory(division: "Paints")

        // When
        let viewModel = FactoryDetailsViewModel(factory: factory)

        // Then
        XCTAssertEqual(viewModel.division, "Division: Paints")
    }

    func test_GivenAddressAndCountry_WhenCreated_ThenCombineThem() {
        // Given
        let factory = Factory(country: "CA", address: "93 Becar, Quebec")

        // When
        let viewModel = FactoryDetailsViewModel(factory: factory)

        // Then
        XCTAssertEqual(viewModel.address, "Address: 93 Becar, Quebec, CA")
    }
}
