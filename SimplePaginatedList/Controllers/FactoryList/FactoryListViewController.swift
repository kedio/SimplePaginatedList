//
//  FactoryListViewController.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import UIKit

class FactoryListViewController: UITableViewController {
    // MARK: Properties

    private var rows: [Row] = []

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        register(cellType: FactoryCell.self)
        register(cellType: FactoryPlaceholderCell.self)

        rows = [
            .factory(
                viewModel: FactoryCellViewModel(
                    factory: Factory(
                        id: 0,
                        name: "Final",
                        division: "",
                        country: "",
                        address: ""
                    )
                )
            ),
            .placeholder,
            .placeholder,
            .placeholder
        ]
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
        return row.cell(in: tableView, at: indexPath)
    }
}

extension FactoryListViewController {
    enum Row {
        case factory(viewModel: FactoryCellViewModel)
        case placeholder

        func cell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
            switch self {
            case let .factory(viewModel):
                guard let cell = dequeue(cell: FactoryCell.self, in: tableView, at: indexPath) else {
                    return UITableViewCell()
                }

                cell.configure(viewModel: viewModel)
                return cell

            case .placeholder:
                guard let cell = dequeue(cell: FactoryPlaceholderCell.self, in: tableView, at: indexPath) else {
                    return UITableViewCell()
                }

                return cell
            }
        }

        func dequeue<T: NibLoadable>(cell: T.Type, in tableView: UITableView, at indexPath: IndexPath) -> T? {
            tableView.dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as? T
        }
    }
}
