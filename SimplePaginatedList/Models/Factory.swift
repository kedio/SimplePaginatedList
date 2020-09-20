//
//  Factory.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-19.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Foundation

struct Factory: Codable {
    let id: Int
    let name: String
    let division: String
    let country: String
    let address: String

    init(id: Int = 0,
         name: String = "",
         division: String = "",
         country: String = "",
         address: String = "") {
        self.id = id
        self.name = name
        self.division = division
        self.country = country
        self.address = address
    }
}
