//
//  BotPropertyTableCell.swift
//  DreamhouseBot MessagesExtension
//
//  Created by Quinton Wall on 3/21/18.
//  Copyright © 2018 me.quinton. All rights reserved.
//


import UIKit
import SDWebImage


class BotPropertyTableCell: UITableViewCell {
    
    @IBOutlet var propertyImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet weak var numBedrooms: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet weak var numBathrooms: UILabel!
    
    
    
    
    var propertyImageURLString = "" {
        didSet {
            self.propertyImageView.sd_setImage(with: URL(string: propertyImageURLString))
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
