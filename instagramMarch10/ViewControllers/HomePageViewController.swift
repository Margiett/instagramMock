//
//  HomePageViewController.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 5/1/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var homePageCollectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    
    private var feed = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.homePageCollectionView.reloadData()
            }
        }
        
    }
    
//    private var feed = [Post]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.homePageCollectionView.reloadData()
//            }
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homePageCollectionView.dataSource = self
        homePageCollectionView.delegate = self
        

    }
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(true)
         
         listener = Firestore.firestore().collection(DatabaseService.postCollecion).addSnapshotListener({ [weak self] (snapshot, error) in
            
             if let error = error {
                 DispatchQueue.main.async {
                     self?.showAlert(title: "Try again later", message: "There is a FireStore error: \(error.localizedDescription)")
                 }
             } else if let snapshot = snapshot {
                print("there are \(snapshot.documents.count) in the feed")
                 let posts = snapshot.documents.map { Post($0.data()) }
                 self?.feed = posts
                 }
             })
         }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove()
    }

}





extension HomePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCell else {
            fatalError("could not downcast to feedCell")
        }
        let post = feed[indexPath.row]
        cell.configureCell(post: post)
        
        return cell
    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize = UIScreen.main.bounds
        return CGSize(width: maxSize.width, height: maxSize.height * 0.70)
    }
}
