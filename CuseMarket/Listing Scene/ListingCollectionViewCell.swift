//
//  ListingCollectionViewCell.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/1/22.
//

import UIKit

class ListingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var listingImageView: UIImageView!
    
    func setup(with image: UIImage) {
        listingImageView.image = image
    }
}
