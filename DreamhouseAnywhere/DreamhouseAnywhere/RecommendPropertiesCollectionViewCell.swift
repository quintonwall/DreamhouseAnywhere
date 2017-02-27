//
//  RecommendPropertiesCollectionViewCell.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/27/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit
import SDWebImage
import DreamhouseKit

class RecommendPropertiesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var propertyImageView: UIImageView!
     var property : Property!
    
    var propertyImageURLString = "" {
        didSet {
            self.propertyImageView.sd_setImage(with: URL(string: propertyImageURLString))
        }
    }

    
}
