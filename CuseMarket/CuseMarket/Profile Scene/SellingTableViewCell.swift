//
//  SellingTableViewCell.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/6/22.
//

import UIKit

class SellingTableViewCell: UITableViewCell {

    @IBOutlet weak var sellingImageView: UIImageView!
    @IBOutlet weak var sellingProductName: UILabel!
    @IBOutlet weak var sellingProductPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
