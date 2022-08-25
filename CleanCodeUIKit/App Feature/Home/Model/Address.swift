//
//  Address.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 25/08/22.
//

import Foundation

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}
