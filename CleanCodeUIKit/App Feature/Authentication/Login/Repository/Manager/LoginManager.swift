//
//  LoginManager.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 21/08/22.
//

import Foundation

struct LoginManager {
    
    private let repository: UserRepository
    
    init(repository: UserRepository = UserLocalRepository()) {
        self.repository = repository
    }
    
    func create(user: LoginRequest) {
        repository.create(user)
    }
    
    func isRegistered(user: LoginRequest)-> ValidationResult {
        repository.validate(user)
    }
    
    func validate(user: LoginRequest) -> ValidationResult {
        repository.validate(user)
    }
}
