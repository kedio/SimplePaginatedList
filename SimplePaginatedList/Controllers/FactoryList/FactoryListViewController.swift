//
//  FactoryListViewController.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import UIKit

class FactoryListViewController: UITableViewController {
    // MARK: Alias

    typealias Row = FactoryListViewModel.Row

    // MARK: Properties

    private let viewModel = FactoryListViewModel()
    private var cancelBag = Set<AnyCancellable>()
    private var rows: [Row] = []

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        register(cellType: FactoryCell.self)
        register(cellType: FactoryPlaceholderCell.self)

        viewModel.$rows
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] rows in
                self?.rows = rows
                self?.tableView.reloadData()
            })
            .store(in: &cancelBag)
    }

    private func register(cellType: NibLoadable.Type) {
        tableView.register(cellType.nib, forCellReuseIdentifier: cellType.identifier)
    }

    // MARK: TableView DataSource and Delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard rows.count > indexPath.row else { return UITableViewCell() }

        let row = rows[indexPath.row]
        return cell(for: row, in: tableView, at: indexPath) ?? UITableViewCell()
    }

    private func cell(for row: Row, in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        switch row {
        case let .factory(viewModel):
            let cell = dequeue(cell: FactoryCell.self, in: tableView, at: indexPath)
            cell?.configure(viewModel: viewModel)
            return cell

        case .placeholder:
            let cell = dequeue(cell: FactoryPlaceholderCell.self, in: tableView, at: indexPath)
            return cell
        }
    }

    private func dequeue<T: NibLoadable>(cell: T.Type, in tableView: UITableView, at indexPath: IndexPath) -> T? {
        tableView.dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as? T
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplay(index: indexPath.row)
    }
}
