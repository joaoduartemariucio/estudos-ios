//
//  AppDelegate.swift
//  Mapbox Samples
//
//  Created by João Vitor Duarte Mariucio on 29/07/20.
//  Copyright © 2020 João Vitor Duarte Mariucio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        
        return true
    }
}

