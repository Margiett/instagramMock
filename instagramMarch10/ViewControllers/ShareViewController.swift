//
//  ShareViewController.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 5/1/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ShareViewController: UIViewController {
    
    @IBOutlet weak var writeCaptionText: UITextField!
    @IBOutlet weak var uploadPhoto: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    private var selectedImage: UIImage
    private let db = DatabaseService()
    private let storageService = StorageService()
    private let database = Firestore.firestore()
    
    init?(coder: NSCoder, selectedImage: UIImage) {
        self.selectedImage = selectedImage
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("the coder has not been implemented ")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        uploadPhoto.image = selectedImage

        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        guard let caption = writeCaptionText.text, !caption.isEmpty else {
            captionLabel.textColor = #colorLiteral(red: 0.83209306, green: 0.5366696119, blue: 0.8646921515, alpha: 1)
            captionLabel.text = "Caption is Required !"
            print("testing share button was pressed ")
            return
        }
    }

    

}
