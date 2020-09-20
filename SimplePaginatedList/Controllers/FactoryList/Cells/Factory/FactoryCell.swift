//
//  FactoryCell.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation
import UIKit

class FactoryCell: UITableViewCell {
    // MARK: IBOutlets

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var divisionLabel: UILabel!

    // MARK: Properties

    private var cancelBag = Set<AnyCancellable>()

    // MARK: Configuration

    func configure(viewModel: FactoryCellViewModel) {
        viewModel.$name
            .assign(to: \.text, on: nameLabel)
            .store(in: &cancelBag)

        viewModel.$division
            .assign(to: \.text, on: divisionLabel)
            .store(in: &cancelBag)
    }
}
