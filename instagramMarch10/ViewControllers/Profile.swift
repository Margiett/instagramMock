//
//  Profile.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 5/5/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class Profile: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    
    public var instaUser: UserModel?
    private var userPost = [Post]() {
        didSet{
            self.collectionView.reloadData()
            if self.userPost.isEmpty {
                self.collectionView.backgroundView = EmptyView(title: "No Posts", message: "Share your most memorable momments with us")
            } else {
                self.collectionView.backgroundView = nil
                
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        editProfileButton.layer.borderColor = #colorLiteral(red: 0.83209306, green: 0.5366696119, blue: 0.8646921515, alpha: 1)
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.cornerRadius = 6
        userImageView.layer.cornerRadius = userImageView.frame.width/2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        listener = Firestore.firestore().collection(DatabaseService.postCollecion).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Please try again later", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let post = snapshot.documents.map { Post($0.data())}
                self?.userPost = post.filter { $0.userId == user.uid }
            }
        })
        loadUserInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        loadUserInfo()
    }
    
    private func loadUserInfo(){
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        if let photoURL = user.photoURL {
            userImageView.kf.setImage(with: photoURL)
        }
        if let username = user.displayName {
            navigationItem.title = username
        }
    }
    
    @IBAction func signOutPressedButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            UIViewController.showViewController(storyBoardName: "Login", viewControllerId: "LoginViewController")
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Error signing out", message: "\(error.localizedDescription)")
            }
        }
        
    }
    
    
}


extension Profile: UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           userPost.count
       }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? UserPostCell else {
            fatalError("could not downcast to postCell")
        }
        let post = userPost[indexPath.row]
        cell.configureCell(post: post)
        return cell
    }
    
   
}

extension Profile: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let interItemSpacing: CGFloat = 10
        let maxWidth = UIScreen.main.bounds.size.width
        
        let numberOfItems: CGFloat = 3
        let totalSpacing: CGFloat = numberOfItems * interItemSpacing
        
        let itemWidth: CGFloat = (maxWidth - totalSpacing)/numberOfItems
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
}
