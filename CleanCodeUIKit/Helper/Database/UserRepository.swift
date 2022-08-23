//
//  UserRepository.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 21/08/22.
//

import Foundation

protocol UserRepository {
    func create(_ user: User)
    func fetchAll() -> [User]
    func validate(_ user: User) -> Bool
}
