//
//  GeoCodeService.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-20.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import CoreLocation
import Foundation

protocol GeocoderService {
    func getCoordinate(for address: String) -> AnyPublisher<CLLocationCoordinate2D, Error>
}

enum GeocoderServiceError: Error {
    case unexpected
}

class CoreLocationGeocoderService: GeocoderService {
    let geocoder = CLGeocoder()

    func getCoordinate(for address: String) -> AnyPublisher<CLLocationCoordinate2D, Error> {
        return Future { [weak self] promise in
            self?.geocoder.geocodeAddressString(address) { placeMarks, error in
                if let error = error {
                    promise(.failure(error))
                } else if let coordinate = placeMarks?.first?.location?.coordinate {
                    promise(.success(coordinate))
                } else {
                    promise(.failure(GeocoderServiceError.unexpected))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
