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
    private let fireStore = Firestore.firestore()
    
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
    }
    
    //MARK: Share Button needs to fix this error
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        guard let caption = writeCaptionText.text, !caption.isEmpty else {
            captionLabel.textColor = .red
            captionLabel.text = "A caption is required in order to post"
            return
        }
        
        let reSizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: uploadPhoto.bounds)
        
        db.createPost(caption: caption) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error creating item", message: error.localizedDescription)
                }
            case .success(let postId):
                self.uploadingPicture(image: reSizedImage, postId: postId)
            }
        }
        
    }







    private func uploadingPicture(image: UIImage, postId: String) {
        
        storageService.uploadPhoto(postId: postId, image: image) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error uploading photos", message: "\(error.localizedDescription)")
                }
            case.success(let url):
                self?.updateImageURL(url, postId: postId)
            }
        }
    }
    private func updateImageURL(_ url: URL, postId: String) {
        fireStore.collection(DatabaseService.postCollecion).document(postId).updateData(["imageURL": url.absoluteString]) { [weak self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "failed to update post image", message: "\(error.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                    }
                }
            }
            
        }
    }
    

