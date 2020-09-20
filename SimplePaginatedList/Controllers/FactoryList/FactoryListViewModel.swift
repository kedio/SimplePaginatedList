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

    // MARK: Constants

    private let itemPerPage = 10

    // MARK: Properties

    private let repository: FactoryRepository
    private var cancelBag = Set<AnyCancellable>()
    private var offsetsRequested = Set<Int>()

    // MARK: Initialization

    init(repository: FactoryRepository = DefaultFactoryRepository()) {
        self.repository = repository
    }

    // MARK: Events

    func willDisplayRow(at index: Int) {
        let pageOffset = Int(index / itemPerPage) * itemPerPage

        guard !offsetsRequested.contains(pageOffset) else { return }

        offsetsRequested.insert(pageOffset)

        repository.fetch(at: pageOffset)
            .sink(receiveCompletion: { [weak self] completion in
                self?.finishRequest(with: completion, for: pageOffset)
            }, receiveValue: { [weak self] factoryList in
                self?.updateRows(with: factoryList, for: pageOffset)
            })
            .store(in: &cancelBag)
    }

    private func finishRequest(with completion: Subscribers.Completion<Error>, for pageOffset: Int) {
        if case .failure = completion {
            offsetsRequested.remove(pageOffset)
        }
    }

    private func updateRows(with factoryList: FactoryList, for pageOffset: Int) {
        rows = (0 ..< factoryList.count).map { index in
            if shouldUpdate(index, for: pageOffset, with: factoryList) {
                let factory = factoryList.results[index - pageOffset]
                return .factory(viewModel: FactoryCellViewModel(factory: factory))
            } else if index < rows.count {
                return rows[index]
            } else {
                return .placeholder
            }
        }
    }

    private func shouldUpdate(_ index: Int, for pageOffset: Int, with factoryList: FactoryList) -> Bool {
        return pageOffset <= index && index < pageOffset + factoryList.results.count
    }
}

extension FactoryListViewModel {
    enum Row {
        case factory(viewModel: FactoryCellViewModel)
        case placeholder
    }
}
