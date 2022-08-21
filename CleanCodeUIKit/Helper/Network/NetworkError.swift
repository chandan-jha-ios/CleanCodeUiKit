//
//  NetworkError.swift
//  CleanCodeMVVM
//
//  Created by Chandan Jha on 06/08/22.
//

import Foundation

/** NetworkError is the common error, this will give flexibility to do customisation of error message in one format as a  consistency*/
struct NetworkError: Error {
    var statusCode: Int?
    let description: String?
}

/** Common error messages */
enum ErrorKeys: String {
    case somethingWentWrong = "Something went wrong"
    case fileNotFound = "File not found"
    case parsingFailed = "Parsing failed"
}
