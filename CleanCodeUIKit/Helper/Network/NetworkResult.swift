//
//  NetworkResult.swift
//  CleanCodeMVVM
//
//  Created by Chandan Jha on 06/08/22.
//

import Foundation

/** NetworkResult  will give flexibility to deal with `codable models` in case of success or give failure with common `NetworkError` */
enum NetworkResult<T: Codable> {
    case success(T)
    case failure(NetworkError)
}

enum LoginResult {
    case success
    case failure(NetworkError)
}

