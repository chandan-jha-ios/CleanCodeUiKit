//
//  Requestable.swift
//  CleanCodeMVVM
//
//  Created by Chandan Jha on 05/08/22.
//

import Foundation
import Alamofire

/** Types of HTTPMethod requests*/
enum RequestMethod: String {
    case GET, POST, PUT, DELETE
}

/** Version can help to maintain the different api request depending on versions*/
enum Version: String {
    case v1, v2, v3
}

/*** Requestable protocol will be used while creating any Service and have common implementation.
 Here urlRequest func in extension is added to to deal with any Services and provide the common logic to generate the url*/
protocol Requestable {
    var server: String? { get }
    var method: RequestMethod { get }
    var headers: [String: String] { get }
    var encoding: URLEncoding { get }
    var params: [String: Any]? { get }
    var path: String { get }
    var endPoints: String? { get }
    var version: Version? { get }
}

extension Requestable {
    
    var server: String? {
        Constant.baseUrl
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var version: Version? {
        nil
    }
    
    var url: URL? {
        guard var server = server else { return nil }
        server = server.appendPath(version: version, path: path)
        server = server.appendEndPoint(endPoints)
        return URL(string: server)
    }
    
    func urlRequest() throws -> URLRequest {
        guard let url = url else {
            throw NetworkError(statusCode: nil, description: "Url is nil")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        do {
            return try encoding.encode(request, with: params)
        } catch {
            throw NetworkError(statusCode: nil, description: "Request conversion failed")
        }
    }
    
}
