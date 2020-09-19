//
//  NibLoadable.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadable {
    static var nib: UINib { get }
    static var identifier: String { get }
}

extension NibLoadable where Self: UIView {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }

    static var identifier: String {
        return String(describing: self)
    }

    static func loadFromNib() -> Self? {
        let view = nib.instantiate(withOwner: nil, options: nil).first
        return view as? Self
    }
}
