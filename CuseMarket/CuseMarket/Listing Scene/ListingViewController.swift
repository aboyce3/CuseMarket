//
//  ListingViewController.swift
//  CuseMarket
//
//  Created by Andrew Boyce on 4/27/22.
//

import UIKit
import Firebase
import Photos
import PhotosUI

class ListingViewController: UIViewController {
    
    var photos: [UIImage] = []
    var product: Product?

    @IBOutlet weak var listingCollectionView: UICollectionView!
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var PriceTextField: UITextField!
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var conditionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CollectionView set up
        listingCollectionView.dataSource = self
        listingCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        listingCollectionView.collectionViewLayout = layout
        // ImageView set up
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        listingCollectionView.isUserInteractionEnabled = true
        listingCollectionView.addGestureRecognizer(gesture)
    }
    
    @objc func imageTapped() {
        presentPhotoActionSheet()
    }
    
    @IBAction func didTapCategory(_ sender: Any) {
        let categoryAction = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
        categoryAction.addAction(UIAlertAction(title: "Clothing", style: .default, handler: { action in
            self.categoryButton.setTitle("Clothing", for: .normal)
            categoryAction.dismiss(animated: true)
        }))
        categoryAction.addAction(UIAlertAction(title: "Furniture", style: .default, handler: { action in
            self.categoryButton.setTitle("Furniture", for: .normal)
            categoryAction.dismiss(animated: true)
        }))
        categoryAction.addAction(UIAlertAction(title: "Electronic", style: .default, handler: { action in
            self.categoryButton.setTitle("Electronic", for: .normal)
            categoryAction.dismiss(animated: true)
        }))
        categoryAction.addAction(UIAlertAction(title: "House", style: .default, handler: { action in
            self.categoryButton.setTitle("House", for: .normal)
            categoryAction.dismiss(animated: true)
        }))
        categoryAction.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(categoryAction, animated: true)
    }
    
    @IBAction func didTapCondition(_ sender: Any) {
        let conditionAction = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
        conditionAction.addAction(UIAlertAction(title: "New", style: .default, handler: { action in
            self.conditionButton.setTitle("New", for: .normal)
            conditionAction.dismiss(animated: true)
        }))
        conditionAction.addAction(UIAlertAction(title: "Used - Like new", style: .default, handler: { action in
            self.conditionButton.setTitle("Used - Like new", for: .normal)
            conditionAction.dismiss(animated: true)
        }))
        conditionAction.addAction(UIAlertAction(title: "Used - Good", style: .default, handler: { action in
            self.conditionButton.setTitle("Used - Good", for: .normal)
            conditionAction.dismiss(animated: true)
        }))
        conditionAction.addAction(UIAlertAction(title: "Used - Fair", style: .default, handler: { action in
            self.conditionButton.setTitle("Used - Fair", for: .normal)
            conditionAction.dismiss(animated: true)
        }))
        conditionAction.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(conditionAction, animated: true)
    }
    
    @IBAction func didTapListProduct(_ sender: Any) {
        // upload product data to Firebase and dismiss the screen
    }
    
}

extension ListingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListingCollectionViewCell", for: indexPath) as! ListingCollectionViewCell
        cell.setup(with: photos[indexPath.row])
        return cell
    }
}

extension ListingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}

extension ListingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Product Picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
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
        let config = PHPickerConfiguration(photoLibrary: .shared())
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        photos.append(selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                self.photos.append(image)
            }
        }
    }
}
