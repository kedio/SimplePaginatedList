//
//  GeoCoderServiceIntegrationTests.swift
//  SimplePaginatedListIntegrationTests
//
//  Created by Kevin Dion on 2020-09-20.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import CoreLocation
import Foundation
@testable import SimplePaginatedList
import XCTest

class GeocoderServiceIntegrationTests: XCTestCase {
    // MARK: Properties

    var cancelBag = Set<AnyCancellable>()

    // MARK: Test fetch and mapping

    func test_GivenService_WhenGettingCoordinate_ThenReceiveIt() {
        // Given
        let service = CoreLocationGeocoderService()
        let expected = expectation(description: "Should complet request")

        // When
        var receivedCoordinate: CLLocationCoordinate2D?
        service.getCoordinate(for: "240 Avenue Saint-Sacrement, Quebec City, QC")
            .sink(receiveCompletion: { _ in
                expected.fulfill()
            }, receiveValue: { coordinate in
                receivedCoordinate = coordinate
            })
            .store(in: &cancelBag)

        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(receivedCoordinate)
    }
}
