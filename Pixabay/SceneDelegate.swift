//
//  SceneDelegate.swift
//  Pixabay
//
//  Created by Askar on 02.02.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window?.windowScene = windowScene
        window?.makeKeyAndVisible()

        let viewController = GalleryViewController()
        let navViewController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navViewController
    }
}

