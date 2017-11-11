//
//  RestaurantDetailTableViewCell.swift
//  Restaurant Locator
//
//  Created by pro on 2017/9/4.
//  Copyright © 2017年 pro. All rights reserved.
//

import UIKit

class RestaurantDetailTableViewCell: UITableViewCell {
    // custom restaurant detail tableview cell
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
