//
//  FactoryListViewModel.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation

class FactoryListViewModel {
    // MARK: Bindings

    @Published var rows: [Row] = Array(repeating: .placeholder, count: 50)

    // MARK: Properties

    private let repository: FactoryRepository
    private var cancelBag = Set<AnyCancellable>()

    // MARK: Initialization

    init(repository: FactoryRepository = DefaultFactoryRepository()) {
        self.repository = repository
    }

    // MARK: Events

    func willDisplay(index: Int) {
        repository.fetch(at: index)
            .sink(receiveCompletion: { completion in
                print("\(index) \(completion)")
            }, receiveValue: { [weak self] factoryList in
                self?.rows = (0 ..< factoryList.count).map { _ in
                    .placeholder
                }
            })
            .store(in: &cancelBag)
    }
}

extension FactoryListViewModel {
    enum Row {
        case factory(viewModel: FactoryCellViewModel)
        case placeholder
    }
}
