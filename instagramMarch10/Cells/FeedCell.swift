//
//  FeedCell.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 5/1/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth

class FeedCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var bottomUsernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func layoutSubviews() {
        userImage.layer.cornerRadius = userImage.frame.width/2
    }
    public func configureCell(post: Post) {
        
        if let user = Auth.auth().currentUser,
            let displayName = user.displayName {
            userImage.kf.setImage(with: user.photoURL)
            usernameLabel.text = displayName
            bottomUsernameLabel.text = displayName
        } else {
            userImage.image = UIImage(systemName: "person.fill")
            userImage.image?.withTintColor(.gray)
            usernameLabel.text = post.userName
            bottomUsernameLabel.text = "@\(post.userName)"
        }
        postedImage.kf.setImage(with: URL(string: post.imageURL))
        captionLabel.text = post.caption
        

    }
    
}
