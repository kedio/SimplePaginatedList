//
//  SubscribersExtensions.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-20.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation

extension Subscribers.Completion {
    var success: Bool {
        switch self {
        case .finished:
            return true
        case .failure:
            return false
        }
    }
}
