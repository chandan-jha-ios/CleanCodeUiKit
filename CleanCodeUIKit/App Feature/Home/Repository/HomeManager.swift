//
//  HomeManager.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 23/08/22.
//

typealias UserCompletion = ((NetworkError?, [UserData]?) -> Void)

protocol UserFetchable {
    func fetchUsers(service: Requestable, completion: @escaping UserCompletion)
}

/// All the api network call be trigereed here for home view model
struct HomeManager: UserFetchable {

    private let networkAdaptor: NetworkAdaptor
        
    init(networkAdaptor: NetworkAdaptor = NetworkManager()) {
        self.networkAdaptor = networkAdaptor
    }
    
    func fetchUsers(service: Requestable, completion: @escaping UserCompletion) {
        guard let request = try? service.urlRequest() else {
            completion(NetworkError(statusCode: nil, description: "Something went wrong"), nil)
            return
        }
        networkAdaptor.process(urlRequest: request, type: [UserData].self) { result in
            switch result {
            case let .success(users):
                completion(nil, users)
            case let .failure(error):
                completion(error, nil)
            }
        }
    }
}
