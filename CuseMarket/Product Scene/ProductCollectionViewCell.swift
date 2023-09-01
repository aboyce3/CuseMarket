//
//  ProductCollectionViewCell.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 4/30/22.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    func setup(with image: UIImage) {
        productImageView.image = image
    }
}
