//
//  SceneDelegate.swift
//  mvvm-kit
//
//  Created by Владислав Пермяков on 08.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootNav = UINavigationController(rootViewController: HotelListViewController())
        window.rootViewController = rootNav
        self.window = window
        window.makeKeyAndVisible()
    }
}

