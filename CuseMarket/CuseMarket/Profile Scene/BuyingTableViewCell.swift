//
//  BuyingTableViewCell.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/7/22.
//

import UIKit

class BuyingTableViewCell: UITableViewCell {

    @IBOutlet weak var buyingImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(title: String, price: String, coverPhoto: UIImage) {
        buyingImageView.image = coverPhoto
        productNameLabel.text = title
        productPriceLabel.text = price
    }

}
