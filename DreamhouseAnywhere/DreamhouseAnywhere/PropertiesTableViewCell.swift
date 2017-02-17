//
//  PropertiesTableViewCell.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/7/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit
import SDWebImage
import Spring



class PropertiesTableViewCell: UITableViewCell {

    @IBOutlet var propertyImageView:UIImageView!
    @IBOutlet weak var numBedrooms: UILabel!
    @IBOutlet weak var numBathrooms: UILabel!
    @IBOutlet var price:UILabel!
    @IBOutlet weak var favoriteIndicatorButton: SpringButton!
    @IBOutlet weak var favoriteAnimationImageView: SpringImageView!
    var isFavorite : Bool = false  {
        didSet {
            if(self.isFavorite == true) {
                self.favoriteIndicatorButton.isHidden = false
                favoriteIndicatorButton.animation = "fadeIn"
                favoriteIndicatorButton.duration = 2
                favoriteIndicatorButton.animate()
            } else {
                favoriteIndicatorButton.animation = "fadeOut"
                favoriteIndicatorButton.duration = 2
                favoriteIndicatorButton.animate()
                //self.favoriteIndicatorButton.isHidden = true

            }
        }
    }

    var propertyImageURLString = "" {
        didSet {
            self.propertyImageView.sd_setImage(with: URL(string: propertyImageURLString))
        }
    }
    


     func doubleTappedForFavorite() {
        
        if(!isFavorite) {
            self.isFavorite = true
            self.favoriteAnimationImageView.isHidden = false
            favoriteAnimationImageView.duration = 1
            favoriteAnimationImageView.animation = "zoomOut"
            favoriteAnimationImageView.animate()
        }
       
        
    }
    
    @IBAction func unfavoriteTapped(_ sender: Any) {
        self.isFavorite = false
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         favoriteAnimationImageView.isHidden = true
        favoriteIndicatorButton.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTappedForFavorite))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
