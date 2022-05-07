//
//  StorageManager.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/5/22.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    func uploadProductImages(image: UIImage, productID: String, imageID: String) {
        let ref = storage.child("Products").child(productID).child(imageID)
        if let data = image.pngData() {
            ref.putData(data)
            }
        }
    
    func getProductImages(productID: String, completion: @escaping ([UIImage]?) -> Void) {
        let ref = storage.child("Products").child(productID)
        var images: [UIImage] = []
        ref.listAll { result, error in
            if let error1 = error {
                print(error1)
            }
            for item in result.items {
                item.downloadURL { url, error in
                    if let error2 = error {
                        print(error2)
                        completion(nil)
                    } else {
                        if let urlData = url, let data = try? Data(contentsOf: urlData.absoluteURL) {
                            let image = UIImage(data: data)
                            images.append(image!)
                        }
                        completion(images)
                    }
                }
            }
        }
        
    }
    
    func getProductFirstImage(productID: String, completion: @escaping (UIImage?) -> Void) {
        let ref = storage.child("Products").child(productID).child("0")
        //var image: UIImage
        ref.downloadURL { url, error in
            if let error1 = error {
                print(error1)
                completion(UIImage(systemName: "photo.artframe"))
            } else {
                if let urlData = url, let data = try? Data(contentsOf: urlData.absoluteURL) {
                    let image = UIImage(data: data)
                    completion(image)
                }
            }
            
        }
        
    }
}
