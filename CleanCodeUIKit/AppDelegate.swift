//
//  AppDelegate.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 18/08/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        showHomeOrLogin()
        return true
    }

    @objc func showHomeOrLogin() {
        if UserDefaults.standard.value(forKey: "user") != nil,
           let controller = HomeController.loadController() {
            let navigation = UINavigationController(rootViewController: controller)
            window?.rootViewController = navigation
        } else if let controller = LoginController.loadController() {
            let navigation = UINavigationController(rootViewController: controller)
            window?.rootViewController = navigation
        }
    }
    
}

