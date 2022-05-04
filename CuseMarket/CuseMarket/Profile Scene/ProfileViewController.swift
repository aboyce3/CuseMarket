//
//  ProfileViewController.swift
//  CuseMarket
//
//  Created by Andrew Boyce on 4/27/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
class ProfileViewController: UIViewController {

    @IBOutlet weak var inboxButtion: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var sellingButton: UIButton!
    @IBOutlet weak var buyingButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    var storageRef = Storage.storage().reference()
    var observer: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let islandRef = storageRef.child("profilePictures/" + Auth.auth().currentUser!.uid + ".png")
        islandRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
          if let error = error {
              print(error.localizedDescription)
          } else {
              self.profileImageView.image = UIImage(data: data!)
          }
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(gesture)
        
        observer = profileImageView.observe(\.image, options: [.old, .new], changeHandler: { imageView, _ in
            guard let _ = imageView.image else {
                return
            }
            self.uploadProfilePicture()
        })
    }
    
    @objc func imageTapped() {
        presentPhotoActionSheet()
    }
    
    func uploadProfilePicture() {
        storageRef = Storage.storage().reference().child("profilePictures/" + Auth.auth().currentUser!.uid + ".png")
        if let uploadData = self.profileImageView.image!.pngData() {
                storageRef.putData(uploadData)
        }
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        do {
            try? Auth.auth().signOut()
            let navViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogInNav") as? UINavigationController
            self.view.window?.rootViewController = navViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true // user can crop and edit photos they have picked
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.profileImageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
