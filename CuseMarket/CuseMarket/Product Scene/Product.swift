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
    let price: String
    let categroy: String
    let condition: String
    //let latitude: String
    //let longitude: String
    let description: String
    let userID: String
    let productID: String
    // let isSold: Bool
}
