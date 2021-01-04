//
//  AppDelegate.swift
//  SecureEntryTemplate
//
//  Created by Ацкий Станислав on 01.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = PinViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }

}

