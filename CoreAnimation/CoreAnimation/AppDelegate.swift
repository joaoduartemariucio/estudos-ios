//
//  AppDelegate.swift
//  CoreAnimation
//
//  Created by João Vitor Duarte Mariucio on 21/04/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let inicio = ViewController()
        window!.rootViewController = inicio
        window!.makeKeyAndVisible()
        
        return true
    }
}


