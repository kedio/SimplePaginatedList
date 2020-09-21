//
//  FactoryDetailsViewModel.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-20.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation
import MapKit

class FactoryDetailsViewModel {
    // MARK: Bindings

    @Published var isAddressFound = false
    @Published var coordinate = CLLocationCoordinate2D(latitude: 46.80331382418487, longitude: -71.26347770935513)

    @Published var name: String?
    @Published var division: String?
    @Published var address: String?

    // MARK: Properties

    private let geocoderService: GeocoderService
    private var cancelBag = Set<AnyCancellable>()
    let factory: Factory

    // MARK: Initialization

    init(factory: Factory, geocoderService: GeocoderService = CoreLocationGeocoderService()) {
        self.geocoderService = geocoderService
        self.factory = factory
        name = factory.name
        division = "Division: \(factory.division)"
        address = "Address: \(factory.address), \(factory.country)"
    }

    // MARK: Events

    func searchAddress() {
        geocoderService.getCoordinate(for: factory.address)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isAddressFound = completion.success
            }, receiveValue: { [weak self] coordinate in
                self?.coordinate = coordinate
            })
            .store(in: &cancelBag)
    }
}
