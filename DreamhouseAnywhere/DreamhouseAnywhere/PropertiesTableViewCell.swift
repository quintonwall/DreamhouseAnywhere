//
//  PropertiesTableViewCell.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/7/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit

class PropertiesTableViewCell: UITableViewCell {

    @IBOutlet var propertyImageView:UIImageView!
    @IBOutlet var shortTitle:UILabel!
    @IBOutlet var price:UILabel!
    @IBOutlet var longDescription:UILabel!
    @IBOutlet var hotPropertyImageView:UIImageView!
    
    var isHotProperty: Bool = false
    
    var numOfFavorites  = 0 {
        didSet {
            if (numOfFavorites > 5) {
                isHotProperty = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        hotPropertyImageView.layer.cornerRadius = hotPropertyImageView.frame.width / 2
        hotPropertyImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
