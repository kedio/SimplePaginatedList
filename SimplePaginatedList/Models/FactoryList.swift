//
//  File.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Foundation

struct FactoryList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Factory]

    init(count: Int = 0,
         next: String? = nil,
         previous: String? = nil,
         results: [Factory] = []) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
