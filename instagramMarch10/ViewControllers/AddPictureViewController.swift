//
//  AddPictureViewController.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 5/1/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit

class AddPictureViewController: UIViewController {
    
    @IBOutlet weak var pictureLibraryButton: UIButton!
    @IBOutlet weak var cameraButton:UIButton!
    
    
    private lazy var imagePickerController: UIImagePickerController = {
        let image = UIImagePickerController()
        image.delegate = self
        return image
        
    }()
    
    override func viewDidLayoutSubviews() {
        pictureLibraryButton.layer.cornerRadius = 8
        cameraButton.layer.cornerRadius = 8
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func picLibraryButtonPressed(_ sender: UIButton) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true)
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        } else {
            showAlert(title: "Error", message: "No Camera available")
        }
    }

}

extension AddPictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        dismiss(animated: true, completion: nil)
        
        let appView = UIStoryboard(name: "MainView", bundle: nil)
        let sharedVC = appView.instantiateViewController(identifier: "ShareViewController") { (coder) in
        return ShareViewController(coder: coder, selectedImage: image)
            
        }
    }
}
