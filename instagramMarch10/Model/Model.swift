//
//  Model.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 4/30/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import Foundation

struct Post {
    let imageURL: String
   
    let caption: String
    let userId: String
    let userName: String
    let postDate: Data
}

extension Post {
    init(_ dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? "no image"
     
        self.caption = dictionary["caption"] as? String ?? "No caption"
        self.userId = dictionary["userId"] as? String ?? "no user id"
        self.userName = dictionary["userName"] as? String ?? "no user name"
        self.postDate = dictionary["postDate"] as? Data ?? Data()
    }
}
