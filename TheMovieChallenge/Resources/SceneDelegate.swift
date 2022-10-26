//
//  SceneDelegate.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 24/10/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.configureRootController()
        window.makeKeyAndVisible()
        self.window = window
    }
}

