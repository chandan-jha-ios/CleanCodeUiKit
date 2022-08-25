//
//  UserRepository.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 21/08/22.
//

import Foundation

typealias ValidationResult = (Bool, String?)

protocol UserRepository {
    func create(_ user: LoginRequest)
    func fetchAll() -> [LoginRequest]
    func validate(_ user: LoginRequest) -> ValidationResult
}
