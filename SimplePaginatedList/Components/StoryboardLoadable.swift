//
//  StoryboardLoadable.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-20.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardLoadable {
    static var storyboard: UIStoryboard { get }
    static var identifier: String { get }
}

extension StoryboardLoadable where Self: UIViewController {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: identifier, bundle: .main)
    }

    static var identifier: String {
        return String(describing: self)
    }

    static func loadFromStoryboard() -> Self? {
        let viewController = storyboard.instantiateInitialViewController()
        return viewController as? Self
    }
}
