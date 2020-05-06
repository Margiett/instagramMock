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
    static let userCollection = "users"
    
    
    public func createPost(caption: String, completion: @escaping (Result<String, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else { return }
        let documentRef = db.collection(DatabaseService.postCollecion).document() 
        
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
    
    public func createUser(username: String, userBio: String, userId: String, userEmail: String, completion: @escaping (Result<String, Error>) -> ()) {
        guard let user = Auth.auth().currentUser, let displayName = user.displayName, let email = user.email else {return}
        let documentRef = db.collection(DatabaseService.userCollection).document()
        db.collection(DatabaseService.userCollection).document(documentRef.documentID).setData(["username": displayName, "userBio": userBio, "userId": user.uid, "userEmail": email]) { (error) in
            
            if let error = error {
                      completion(.failure(error))
                      print("error creating user: \(error)")
                  } else {
                      completion(.success(documentRef.documentID))
                      print("user was created: \(documentRef.documentID)")
                  }
        }
      
    }
    
    
}
