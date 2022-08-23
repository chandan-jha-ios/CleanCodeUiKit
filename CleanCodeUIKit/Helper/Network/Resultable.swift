//
//  Resultable.swift
//  CleanCodeMVVM
//
//  Created by Chandan Jha on 04/08/22.
//

import Foundation

/**
 Resultable protocol allow to provide  default implementation of parsing the response data from network into models
 It will convert the response data according to the models where Resultable is implemented
 Parsing failure will be resulted as a failure completion with error
 This will support any model where Resultable is implemented
*/
protocol Resultable: Codable {
    func result() -> NetworkResult<Self>
    static func result<T: Resultable>(responseData: Data,
                                      response: HTTPURLResponse?,
                                      isMock: Bool) -> NetworkResult<T>
}

extension Resultable {
    
    /// Here result func will generete the success case of NetworkResult for the owner
    /// Owner can be a generic model where Resultable is implemented
    func result() -> NetworkResult<Self> {
        .success(self)
    }
    
    /// Result func will get the inputs as data, response, isMock and will provide the completion of success or failure
    /// - Paramters:
    /// - responseData: data to convert into models
    /// - response: response to verify the response code validation and do the error mapping
    /// - isMock: Flag to indicate local mock data parsing and avoid validation of response codes
    static func result<T: Resultable>(responseData: Data,
                                      response: HTTPURLResponse? = nil,
                                      isMock: Bool = false) -> NetworkResult<T> {
        guard isMock || response?.validate == true else {
            /// We can do more customisation depending on the error codes here
            return .failure(NetworkError(statusCode: response?.statusCode,
                                         description: ErrorKeys.somethingWentWrong.rawValue))
        }
        do {
            let model = try JSONDecoder().decode(T.self, from: responseData)
            return model.result()
        } catch {
            return .failure(NetworkError(statusCode: nil,
                                         description: "\(T.self) \(ErrorKeys.parsingFailed.rawValue)"))
        }
    }
}

extension Array: Resultable where Element: Resultable { }
