//
//  FactoryCellViewModel.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation

class FactoryCellViewModel {
    // MARK: Bindings

    @Published var name: String?
    @Published var division: String?

    // MARK: Initialization

    init(factory: Factory) {
        name = factory.name
        division = factory.division
    }
}
