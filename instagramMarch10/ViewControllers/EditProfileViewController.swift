//
//  EditProfileViewController.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 5/5/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

class EditProfileViewController: UIViewController {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var emailText: UITextField!
   @IBOutlet weak var bio: UITextField!
  @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    private let storageService = StorageService()
    
    public var instaUserL: UserModel?
    public var selectedUser: User!
    
    private let dataService = DatabaseService()
    private let fireBase = Firestore.firestore()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.profilePicture.image = self.selectedImage
               
            }
            
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
        
        if let userName = user.displayName {
            username.text = userName
        }
        if let userEmail = user.email {
            emailText.text = userEmail
            emailText.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func changePhotoButtonPressed(_ sender: UIButton) {
        
        
        let alertController = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { actionAlert in
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
      
        
        guard let username = username.text, !username.isEmpty,
            let profilePic = selectedImage,
            let userBio = bio.text, !userBio.isEmpty,
            let userPhoneNum = phoneNumber.text, !userPhoneNum.isEmpty else {
                showAlert(title: "Missing Fields", message: "All fields are required to contiune")
                return
        }
      
        guard let user = Auth.auth().currentUser else { return }
        
          let resizedImage = UIImage.resizeImage(originalImage: profilePic, rect: profilePicture.bounds)
        
        instaUserL = UserModel(username: username, userBio: userBio, userId: user.uid, userEmail: user.email ?? "")
        dataService.createUser(username: username, userBio: userBio, userId: user.uid, userEmail: user.email ?? "") { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "unable to save profile pic", message: "\(error.localizedDescription)")
                }
            case .success(let documentID):
                Firestore.firestore().collection(DatabaseService.userCollection).document(documentID).updateData(["username": username, "userBio": userBio])
                
                
            }
        }
     
        
        storageService.uploadPhoto(userId: user.uid, image: resizedImage) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error !!", message: "Error in uploading your profile picture: reson \(error.localizedDescription)")
           
            
            case .success(let url):
                self?.showAlert(title: "Success", message: "Your Profile picture have been uploaded")
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
                        let profileVC = Profile()
                        profileVC.instaUser = self?.instaUserL
                        self?.navigationController?.pushViewController(profileVC, animated: true)
                    }
                })
            }
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
       let profileVC = Profile()
        navigationController?.pushViewController(profileVC, animated: true)
    }
   
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
