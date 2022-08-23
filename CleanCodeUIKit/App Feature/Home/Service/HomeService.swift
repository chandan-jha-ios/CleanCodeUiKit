//
//  HomeService.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 23/08/22.
//

import Foundation
import Alamofire

enum HomeService: Requestable {
    case users

    var method: RequestMethod {
        .GET
    }
    
    var encoding: URLEncoding {
        .default
    }
    
    var params: [String : Any]? {
        nil
    }
    
    var path: String {
        "users"
    }
    
    var endPoints: String? {
        nil
    }

}
