//
//  WKInterfaceImage.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 3/3/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import WatchKit

public extension WKInterfaceImage {
    
    public func setImageWithUrl(url:String, scale: CGFloat = 1.0) -> WKInterfaceImage? {
        
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            if (data != nil && error == nil) {
                let image = UIImage(data: data!, scale: scale)
                
                DispatchQueue.main.async {
                    self.setImage(image)
                }
            }
            }.resume()
        
        return self
    }
}
