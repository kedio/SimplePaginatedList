//
//  FactoryDetailsViewModelTests.swift
//  SimplePaginatedListTests
//
//  Created by Kevin Dion on 2020-09-20.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import CoreLocation
import Foundation
@testable import SimplePaginatedList
import XCTest

class FactoryDetailsViewModelTests: XCTestCase {
    // MARK: Constants

    let defaultCoordinate = CLLocationCoordinate2D(latitude: 46.811978, longitude: -71.2071987)

    // MARK: Properties

    var mockService: MockGeocoderService!

    // MARK: Setup

    override func setUp() {
        mockService = MockGeocoderService()
        mockService.coordinateToReturn = defaultCoordinate
    }

    // MARK: Binding tests

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

    func test_GivenCoordinateFromService_WhenSearchingAddress_ThenHasLocation() {
        // Given
        let viewModel = FactoryDetailsViewModel(factory: Factory(), geocoderService: mockService)

        // When
        viewModel.searchAddress()

        // Then
        XCTAssertEqual(viewModel.coordinate.latitude, defaultCoordinate.latitude)
        XCTAssertEqual(viewModel.coordinate.longitude, defaultCoordinate.longitude)
    }

    func test_GivenCoordinateFromService_WhenSearchingAddress_ThenHideNotFoundLabel() {
        // Given
        let viewModel = FactoryDetailsViewModel(factory: Factory(), geocoderService: mockService)

        // When
        viewModel.searchAddress()

        // Then
        XCTAssertTrue(viewModel.isAddressFound)
    }
}

extension FactoryDetailsViewModelTests {
    class MockGeocoderService: GeocoderService {
        // MARK: Properties

        var coordinateToReturn: CLLocationCoordinate2D?

        // MARK: Geocoder Methods

        func getCoordinate(for address: String) -> AnyPublisher<CLLocationCoordinate2D, Error> {
            if let coordinate = coordinateToReturn {
                return Result.Publisher(coordinate)
                    .eraseToAnyPublisher()
            } else {
                return Result.Publisher(GeocoderServiceError.unexpected)
                    .eraseToAnyPublisher()
            }
        }
    }
}
