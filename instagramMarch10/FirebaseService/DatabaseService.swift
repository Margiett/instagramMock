//
//  DatabaseService.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 4/30/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class DatabaseService {
    
    private let db = Firestore.firestore() // top level of our database
    static let postCollecion = "posts"
    
    public func createPost(caption: String, completion: @escaping (Result<String, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else { return }
        let documentRef = db.collection(DatabaseService.postCollecion).document() // a reference to the of posts collection document - has an auto generated id
        
        db.collection(DatabaseService.postCollecion).document(documentRef.documentID).setData(["caption": caption, "userId": user.uid, "username": user.displayName ?? "", "postDate": Timestamp(date: Date())]) { (error) in
            if let error = error {
                completion (.failure(error))
                print("error creating item: \(error)")
            } else {
                completion (.success(documentRef.documentID))
                print("item was created: \(documentRef.documentID)")
            }
        }
    }
    
    
}
