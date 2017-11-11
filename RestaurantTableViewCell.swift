//
//  RestaurantTableViewCell.swift
//  Restaurant Locator
//
//  Created by pro on 2017/9/4.
//  Copyright © 2017年 pro. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    // ---- custom tableviewcell ----
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
