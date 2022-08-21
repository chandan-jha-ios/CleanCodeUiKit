//
//  NetworkEngine.swift
//  CleanCodeMVVM
//
//  Created by Chandan Jha on 04/08/22.
//

import Foundation
import Alamofire

/** NetworkEngine will do the network request through Session service of Alamofire and do result back to the source
 - Parameters:
    - session: session is the service manager worked as a engine to do the network requests
 */
struct NetworkEngine {
    
    private enum Keys: String {
        case connectionError = "Please check your connection"
        case somethingWrong = "Something went wrong"
    }
    
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    /** request will do the network call and give result back to the source
     - Parameters:
        - urlRequest: request to be passed to the Session for api request
        - type: Codable model with implementation of `Resultable`
        - completion: Will give guarantee of network callback with results of success or failure
     */
    func request<T: Resultable>(urlRequest: URLRequest,
                                type: T.Type,
                                completion: @escaping (NetworkResult<T>) -> Void) {
        guard NetworkReachabilityManager.default?.isReachable == true else {
            completion(.failure(NetworkError(statusCode: nil, description: Keys.connectionError.rawValue)))
            return
        }
        let task = session.request(urlRequest).validate()
        task.responseData { result in
            guard let response = result.response,
                  let data = result.data else {
                      completion(.failure(NetworkError(statusCode: result.response?.statusCode,
                                                       description: Keys.somethingWrong.rawValue)))
                      return
                  }
            completion(T.result(responseData: data, response: response))
        }
    }
}
