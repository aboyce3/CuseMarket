//
//  Product.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/1/22.
//

import Foundation
import UIKit

struct Product: Decodable {
    let title: String
    let price: Int
    let condition: String
    let location: String
    let description: String
    let photos_path: String
    let userID: UUID
}

class ProductList: Decodable {
    let products: [Product]
}
