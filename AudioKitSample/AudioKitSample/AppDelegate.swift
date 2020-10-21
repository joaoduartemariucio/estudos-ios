//
//  AppDelegate.swift
//  AudioKitSample
//
//  Created by João Vitor Duarte Mariucio on 20/08/20.
//  Copyright © 2020 João Vitor Duarte Mariucio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let navController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        navController.pushViewController(ViewController(), animated: true)
        navController.navigationBar.isTranslucent = false
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

