//
//  AppDelegate.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 24/10/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available (iOS 13, *) {
            return true
        }
        let window = UIWindow()
        window.configureRootController()
        window.makeKeyAndVisible()
        return true
    }
}

extension UIWindow {
    func configureRootController() {
        let navController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navController)
        coordinator.start()
        self.rootViewController = navController
    }
}

