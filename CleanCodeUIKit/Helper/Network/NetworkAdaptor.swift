//
//  NetworkAdaptor.swift
//  CleanCodeMVVM
//
//  Created by Chandan Jha on 04/08/22.
//

import Foundation

/** NetworkAdaptor is the protocol to deal with codable models with implementation of Resultable and useful to hide the real functionality of networking. It will give flexibility to deal with remote request or local mock */
protocol NetworkAdaptor {
    func process<T: Resultable>(urlRequest: URLRequest,
                                type: T.Type,
                                completion: @escaping (NetworkResult<T>) -> Void)
}
