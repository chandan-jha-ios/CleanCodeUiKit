//
//  User.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 23/08/22.
//

import Foundation

// MARK: - User
protocol UserPresentable {
    var id: Int { get }
    var name: String { get }
    var username: String  { get }
    var email: String  { get }
}

struct User: UserPresentable, Resultable {
    var id: Int
    var name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

extension User {
    
    var latitude: Double? {
        Double(address.geo.lat)
    }
    
    var longitude: Double? {
        Double(address.geo.lng)
    }
    
    var formattedAddress: String {
        "\(address.street), \(address.suite), \(address.city), ZIP: \(address.zipcode)"
    }
}
