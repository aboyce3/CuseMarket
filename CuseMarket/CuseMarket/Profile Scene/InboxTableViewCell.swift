//
//  InboxTableViewCell.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/6/22.
//

import UIKit

class InboxTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(type: String, message: String) {
        typeLabel.text = type
        messageLabel.text = message
    }

}
