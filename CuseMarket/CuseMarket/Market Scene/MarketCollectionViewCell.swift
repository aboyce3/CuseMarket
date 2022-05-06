//
//  MarketCollectionViewCell.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/5/22.
//

import UIKit

class MarketCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var marketImageView: UIImageView!
    @IBOutlet weak var marketProductTitle: UILabel!
    @IBOutlet weak var marketProductPrice: UILabel!
    
    func setup(with image: UIImage, title: String, price: String) {
        marketImageView.image = image
        marketProductTitle.text = title
        marketProductPrice.text = "Price: $" + price
    }
}
