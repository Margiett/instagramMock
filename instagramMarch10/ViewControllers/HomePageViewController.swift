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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

