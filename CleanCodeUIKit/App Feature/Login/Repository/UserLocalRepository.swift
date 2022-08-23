//
//  UserLocalRepository.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 21/08/22.
//

import Foundation

struct UserLocalRepository: UserRepository {
    enum Keys: String {
        case wrongPassword = "Entered password is wrong"
        case userNotFound = "User is not registered."
    }
    func create(_ user: User) {
        let cdUser = CDUser(context: Persistence.shared.context)
        cdUser.username = user.userName
        cdUser.password = user.password
        cdUser.country = user.country
        Persistence.shared.saveContext()
    }
    
    func fetchAll() -> [User] {
        let users = Persistence.shared.fetchManageObject(object: CDUser.self)
        var userList = [User]()
        users?.forEach({ cdUser in
            userList.append(cdUser.transformToUser())
        })
        return userList
    }
    
    func validate(_ user: User) -> ValidationResult {
        if isUserExist(userName: user.userName) {
            let result = validatePassword(user)
            let message = result ? nil : Keys.wrongPassword.rawValue
            return (result, message)
        } else {
            return (false, Keys.userNotFound.rawValue)
        }
    }
    
    func validatePassword(_ user: User) -> Bool {
        let fetchRequest = CDUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username==%@ && password==%@", user.userName, user.password)
        do {
            let result = try Persistence.shared.context.fetch(fetchRequest)
            return result.isEmpty == false
        } catch let error {
            Utility.log(error.localizedDescription)
        }
        return false
    }
    
    func isUserExist(userName: String) -> Bool {
        let fetchRequest = CDUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username==%@", userName)
        do {
            let result = try Persistence.shared.context.fetch(fetchRequest)
            return result.isEmpty == false
        } catch let error {
            Utility.log(error.localizedDescription)
        }
        return false
    }
}
