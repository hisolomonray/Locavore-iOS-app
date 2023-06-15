//
//  CoffeeShopApp.swift
//  CoffeeShop
//
//  Created by Solomon Ray on 5/10/23.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Enable constraint conflict debug logging
        UserDefaults.standard.setValue(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        return true
    }
}

@main
struct CoffeeShopApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            YelpSearchView(controller: YelpSearchController())
        }
    }
}

