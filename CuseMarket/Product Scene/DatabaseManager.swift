//
//  DatabaseManager.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/5/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}

extension DatabaseManager {
    public func uploadProduct(with product: Product, completion: @escaping (Bool) -> Void) {
        // let productID = database.child("Products").childByAutoId().key
        database.child("Products").child(product.productID).setValue([
            "title": product.title,
            "price": product.price,
            "categroy": product.categroy,
            "condition": product.condition,
            "description": product.description,
            "userID": product.userID,
            "productID": product.productID
        ]) { error, _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            completion(true)
        }
    }
}
