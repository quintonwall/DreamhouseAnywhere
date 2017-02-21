//
//  String.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/21/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import Foundation


extension String {
    
    func substring(start: Int, end: Int) -> String {
        if (start == end || self.strlen() == 0) {
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        return self[startIndex..<endIndex]
    }
    
    func strlen() -> Int {
        return self.characters.count
    }
}
