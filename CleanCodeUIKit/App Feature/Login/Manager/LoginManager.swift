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
    
    func create(user: User) {
        repository.create(user)
    }
    
    func isRegistered(user: User)-> Bool {
        repository.validate(user)
    }
    
    func validate(user: User) -> Bool {
        repository.validate(user)
    }
}
