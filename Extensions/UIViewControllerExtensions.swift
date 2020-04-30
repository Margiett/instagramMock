//
//  UIViewControllerExtensions.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 4/30/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit

extension UIViewController {
    private static func resetWindow(_ rootViewController: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first,
            let sceneDelegate = scene.delegate as? SceneDelegate,
            let window = sceneDelegate.window else {
                fatalError("could not reset window rootViewController")
        }
        window.rootViewController = rootViewController
    }
    public static func showViewController(storyBoardName: String, viewControllerId: String) {
        print(storyBoardName)
        print(viewControllerId)
        let storyboard = UIStoryboard(name: storyBoardName, bundle:  nil)
        let newVC = storyboard.instantiateViewController(identifier: viewControllerId)
        resetWindow(newVC)
    }
}
