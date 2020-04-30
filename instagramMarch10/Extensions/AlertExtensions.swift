//
//  AlertExtensions.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 4/30/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showAlert(title: String?, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    public func showOptionsAlert(title: String?, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes, Get me out.", style: .default, handler: completion)
        let noAction = UIAlertAction(title: "No, I dont know what I want.", style: .default, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
        
    }
}

