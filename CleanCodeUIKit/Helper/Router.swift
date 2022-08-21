//
//  Router.swift
//  CleanCodeMVVM
//
//  Created by Chandan Jha on 06/08/22.
//

import UIKit

protocol Router {
    var context: UINavigationController? { get }
    func configureRoot()
}

extension Router {
    func configureRoot() {}
}

protocol ParentRouter: Router {
    func route(to routeId: String, parameters: Any?)
}

protocol ChildRouter: Router {
    func back()
}

