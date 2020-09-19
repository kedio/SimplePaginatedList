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
}
