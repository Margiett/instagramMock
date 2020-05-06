//
//  EditProfileViewController.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 5/5/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class EditProfileViewController: UIViewController {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var emailText: UITextField!
   // @IBOutlet weak var bio: UITextField!
    // @IBOutlet weak var phoneNumber: UITextField!
    
    
    private let storageService = StorageService()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            profilePicture.image = selectedImage
        }
    }
    
    override func viewDidLayoutSubviews() {
        profilePicture.layer.cornerRadius = profilePicture.frame.width/2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadUserInfo()
    }
    
    private func loadUserInfo(){
        guard let user = Auth.auth().currentUser else {
            return
        }
        if let photoURL = user.photoURL {
            profilePicture.kf.setImage(with: photoURL)
        }
        selectedImage = profilePicture.image
        if let email = user.displayName {
            username.text = email
        }
    }
    
    @IBAction func changePhotoButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { alertController in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = #colorLiteral(red: 0.83209306, green: 0.5366696119, blue: 0.8646921515, alpha: 1)
        present(alertController, animated: true)
    }
    
    @IBAction func doneEditing(_ sender: UIBarButtonItem) {
        guard let selectedImage = selectedImage else {
            return
        }
        guard let user = Auth.auth().currentUser else { return }
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: profilePicture.bounds)
        
        storageService.uploadPhoto(userId: user.uid, image: resizedImage) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error !!", message: "Error in uploading your profile picture: reson \(error.localizedDescription)")
            case .success(let url):
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                
                if let userName = self?.username.text, !userName.isEmpty {
                    request?.displayName = userName
                }
                request?.photoURL = url
                
                request?.commitChanges(completion: { (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error updating profile", message: "Error changing an alert \(error.localizedDescription)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile change", message: "Your profile was successfully created ")
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
   
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
       selectedImage = image
        dismiss(animated: true)
    }
}
