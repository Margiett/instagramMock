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
    private var userPost = [Post]() {
        didSet{
            self.collectionView.reloadData()
            if self.userPost.isEmpty {
                self.collectionView.backgroundView = EmptyView(title: "No Posts have been uploaded yet.", message: "Share your most memorable momments with us")
            } else {
                self.collectionView.backgroundView = nil
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        listener = Firestore.firestore().collection(DatabaseService.postCollecion).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Try again later", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map { Post($0.data()) }
                self?.userPost = posts.filter({ $0.userId == user.uid }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension Profile: UICollectionViewDataSource {
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? UserPostCell else {
            fatalError("could not downcast to postCell")
        }
        let post = userPost[indexPath.row]
        cell.configureCell(post: post)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userPost.count
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
}
