//
//  FactoryDetailsViewModel.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-20.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Foundation
import MapKit

class FactoryDetailsViewModel {
    // MARK: Bindings

    @Published var isAddressFound = false
    @Published var coordinate = CLLocationCoordinate2D(latitude: 46.811978, longitude: -71.2071987)

    @Published var name: String?
    @Published var division: String?
    @Published var address: String?

    // MARK: Properties

    let factory: Factory

    // MARK: Initialization

    init(factory: Factory) {
        self.factory = factory
        name = factory.name
        division = "Division: \(factory.division)"
        address = "Address: \(factory.address), \(factory.country)"
    }
}
