//
//  LoginValidator.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 21/08/22.
//

import Foundation

fileprivate typealias ValidatorTuple = (Bool, String)

protocol LoginValidatable {
    func validate(name: String?) -> (Bool, String)
    func validate(password: String?) -> (Bool, String)
    func validate(value: String?) -> (Bool, String)
}

final class LoginValidator: LoginValidatable {
    
    private enum Keys: String {
        case empty = ""
        case invalid = "Invalid value."
        case invalidPassword = "Use 8 characters long contains 1 upper, lower, symbol and number"
        case shortUserName = "Username is too short."
    }
    
    func validate(name: String?) -> (Bool, String) {
        guard let name = name,
              name.isEmpty == false else {
                  return (false, Keys.empty.rawValue)
              }
        if name.count > 3 {
            return (true, "")
        }
        return (false, Keys.shortUserName.rawValue)
    }
    
    func validate(password: String?) -> (Bool, String) {
        guard let password = password,
              password.isEmpty == false else {
                  return (false, Keys.empty.rawValue)
              }
        if password.isValidPassword {
            return (true, "")
        }
        return (false, Keys.invalidPassword.rawValue)
    }
    
    func validate(value: String?) -> (Bool, String) {
        guard let value = value,
              value.isEmpty == false else {
                  return (false, Keys.empty.rawValue)
              }
        return (true, "")
    }
}
