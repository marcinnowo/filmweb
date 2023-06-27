//
//  AppDelegate.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 24/06/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Container.registerDependecies()
        return true
    }
}

