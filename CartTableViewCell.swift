//
//  CartTableViewCell.swift
//  Startup
//
//  Created by Saransh Mittal on 02/07/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var pricingLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
