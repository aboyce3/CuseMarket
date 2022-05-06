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
    
    func uploadProductImage(image: UIImage, productID: String, imageID: String) {
        let ref = storage.child("Products").child(productID).child(imageID)
        if let data = image.pngData() {
            ref.putData(data)
            }
        }
    
    func getProductImage(completion: @escaping (UIImage) -> Void) {
        
    }
}
