//
//  HomeViewModel.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 23/08/22.
//

import Foundation
import RxRelay
import RxSwift

/// All the business logic for home will be handled here
final class HomeViewModel {
    private let manager: UserFetchable
    let disposeBag = DisposeBag()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let networkError = BehaviorRelay<String>(value: "")
    var users: [User]?
    
    init(manager: UserFetchable = HomeManager()) {
        self.manager = manager
    }
    
    func fetchUsers(service: Requestable = HomeService.users) {
        isLoading.accept(true)
        manager.fetchUsers(service: service) { [weak self] error, users in
            guard error == nil else {
                self?.networkError.accept(error?.description ?? "")
                return
            }
            self?.users = users
            self?.isLoading.accept(false)
        }
    }
    
    var numberOfRows: Int {
        users?.count ?? 0
    }
    
    func user(at index: Int) -> User? {
        guard let users = users, users.count > index else {
            return nil
        }
        return users[index]
    }
}

