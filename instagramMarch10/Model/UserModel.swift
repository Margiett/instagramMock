//
//  UserModel.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 5/5/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import Foundation
import UIKit

struct UserModel {
    let username: String
    let userBio: String
    let userId: String
    let userEmail: String
}

extension UserModel {
    init(_ dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? "no username"
        self.userBio = dictionary["userBio"] as? String ?? "no bio"
        self.userId = dictionary["userId"] as? String ?? "no Id"
        self.userEmail = dictionary["userEmail"] as? String ?? "no email"
    }
}
