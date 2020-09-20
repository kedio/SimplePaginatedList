//
//  FactoryDetailsViewController.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-20.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Foundation
import UIKit

class FactoryDetailsViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet var label: UILabel!

    // MARK: Properties

    var viewModel: FactoryDetailsViewModel?

    // MARK: Configuration

    func configure(viewModel: FactoryDetailsViewModel) {
        self.viewModel = viewModel
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = viewModel?.factory.name
    }
}
