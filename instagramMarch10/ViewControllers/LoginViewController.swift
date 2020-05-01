//
//  LoginViewController.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 5/1/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var authSession = AuthenticationSession()
    
    override func viewDidLayoutSubviews() {
        logInButton.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                print("missing fields")
                return
        }
        
        authSession.signExisitingUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Invalid password or email", message: "\(error.localizedDescription)")
                }
            case .success:
                DispatchQueue.main.async {
                    UIViewController.showViewController(storyBoardName: "MainView", viewControllerId: "MainTabBarController")
                }
            }
        }
    }
    
    
    
    
}
