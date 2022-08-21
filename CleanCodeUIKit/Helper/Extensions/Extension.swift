//
//  Extension.swift
//  CleanCodeMVVM
//
//  Created by Chandan Jha on 05/08/22.
//

import Foundation
import UIKit

/** These validation functions is usefull the validate the server response code handling */
extension HTTPURLResponse {
    
    var validate: Bool {
        return (200...300).contains(self.statusCode)
    }
}

extension String {
    
    func appendPath(version: Version, path: String) -> String {
        var output = self
        output = [output, path].joined(separator: "/")
        
        if !version.rawValue.isEmpty {
            output = [output, version.rawValue].joined(separator: "/")
        }
        return output
    }
    
    func appendEndPoint(_ value: String?) -> String {
        var output = self
        if let value = value,
           !value.isEmpty {
            if value.first == "?" {
                output += value
            } else {
                output = [output, value].joined(separator: "/")
            }
        }
        return  output
    }
}

extension UIImageView {
    
    func addCircle(with color: UIColor? = .white, borderWidth: CGFloat = 2) {
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = color?.cgColor
    }
    
    func rounded(corner radius: CGFloat = 16) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIViewController {
    
    func showAlert(title: String = "Alert", message: String? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}


extension UIViewController {
    
    class var name: String {
        String(describing: self)
    }
    
    func updateAppearance(background: UIColor? = AppColor.theme.value,
                          tint: UIColor = UIColor.black) {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: tint
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationController?.navigationBar.backgroundColor = background
        navigationController?.navigationBar.tintColor = tint
        view.backgroundColor = background
    }
}

extension UITableViewCell {
    
    class var name: String {
        String(describing: self)
    }
}
