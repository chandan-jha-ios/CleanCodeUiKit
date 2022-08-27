//
//  LoginViewModel.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 18/08/22.
//

import RxRelay
import RxSwift

protocol LoginRequestable {
    var result: PublishRelay<LoginResult> { get }
    func login(with user: LoginRequest)
}

fileprivate enum LoginErrorKeys: String {
    case userNotFound = "User not found."
    case emptyFields = "Feilds are empty."
}

final class LoginViewModel: LoginRequestable {
    
    let disposeBag = DisposeBag()
    let username = BehaviorRelay<String?>(value: "")
    let password = BehaviorRelay<String?>(value: "")
    let selectedCountry = BehaviorRelay<String>(value: "")
    let country: [String]
    var result = PublishRelay<LoginResult>()
    var manager: LoginManager
    var validator: LoginValidatable
    
    init(country: [String] = Constant.country,
         manager: LoginManager = LoginManager(),
         validator: LoginValidatable = LoginValidator()) {
        self.country = country
        self.manager = manager
        self.validator = validator
    }
    
    var isValid: Observable<Bool>{
        return Observable.combineLatest(username.asObservable(),
                                        password.asObservable(),
                                        selectedCountry.asObservable())
        { [unowned self] (username, password, country) in
            guard let username = username,
                  let password = password else { return false }
            
            return validator.validate(name: username).0
            && validator.validate(password: password).0
            && validator.validate(value: country).0
        }
    }
    
    var validateForm: Bool {
        validator.validate(name: username.value).0
        && validator.validate(password: password.value).0
        && validator.validate(value: selectedCountry.value).0
    }
    
    var nameFieldError: String {
        validator.validate(name: username.value).1
    }
    
    var passwordFieldError: String {
        validator.validate(password: password.value).1
    }
    
    var countryFieldError: String {
        validator.validate(value: selectedCountry.value).1
    }
    
    func login(with user: LoginRequest) {
        guard user.userName.isEmpty == false else {
            let error = NetworkError(description: LoginErrorKeys.emptyFields.rawValue)
            result.accept(.failure(error))
            return
        }
        let response = manager.isRegistered(user: user)
        if response.0 {
            UserDefaults.standard.set(user.userName, forKey: "user")
            UserDefaults.standard.synchronize()
            result.accept(.success)
        } else {
            let error = NetworkError(description: response.1 ?? "")
            result.accept(.failure(error))
        }
    }
}
