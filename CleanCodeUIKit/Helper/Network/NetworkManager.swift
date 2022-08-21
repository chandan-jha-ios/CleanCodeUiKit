//
//  NetworkManager.swift
//  CleanCodeMVVM
//
//  Created by Chandan Jha on 04/08/22.
//

import Foundation
import Alamofire

/** NetworkManager have implemented the NetworkAdaptor and taking NetworkEngine object as a dependency to request any service call.
 - Parameters:
    - engine: engine will take objecct of NetworkEngine. default is initialized with `Session.default`
 */
struct NetworkManager: NetworkAdaptor {
    var engine: NetworkEngine

    init(engine: NetworkEngine = NetworkEngine(session: Session.default) ) {
        self.engine = engine
    }
    
    func process<T: Resultable>(urlRequest: URLRequest,
                    type: T.Type,
                    completion: @escaping (NetworkResult<T>) -> Void) {
        engine.request(urlRequest: urlRequest, type: type, completion: completion)
    }
    
}
