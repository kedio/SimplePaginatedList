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
    // MARK: Binding

    @Published var name: String?

    init(factory: Factory) {
        name = factory.name
    }
}
