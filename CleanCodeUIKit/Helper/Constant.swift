//
//  Constant.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 21/08/22.
//

import UIKit

struct Constant {
    static var country = ["India", "Singapore", "Europe", "US"]
    static var baseUrl = ""
}

enum AppColor {
    case theme
    case black
    case disabled
    case activeButton
    
    var value: UIColor {
        switch self {
        case .theme:
            return UIColor(hexString: "#77E0C1")
        case .black:
            return UIColor.black
        case .disabled:
            return UIColor.lightGray.withAlphaComponent(0.8)
        case .activeButton:
            return UIColor.systemPink
        }
    }
}
