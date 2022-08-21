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
    func login(user: UserRequest)
}

enum LoginErrorKeys: String {
    case userNotFound = "User not found"
}

final class LoginViewModel: LoginRequestable {
    let disposeBag = DisposeBag()
    let username = BehaviorRelay<String?>(value: "")
    let password = BehaviorRelay<String?>(value: "")
    let selectedCountry = BehaviorRelay<String>(value: "")
    let country: [String]
    var result = PublishRelay<LoginResult>()
    
    init(country: [String] = Constant.country) {
        self.country = country
    }
    
    var isValid: Observable<Bool>{
        return Observable.combineLatest(username.asObservable(),
                                        password.asObservable(),
                                        selectedCountry.asObservable())
        { (username, password, country) in
            guard let username = username,
                  let password = password else { return false }
            
            return username.isEmpty == false
            && password.isEmpty == false
            && country.isEmpty == false
        }
    }
    
    func login(user: UserRequest) {
        print("login requested")
        guard user.userName.isEmpty == false else {
            let error = NetworkError(description: LoginErrorKeys.userNotFound.rawValue)
            result.accept(.failure(error))
            return
            
        }
        result.accept(.success)
    }
}
