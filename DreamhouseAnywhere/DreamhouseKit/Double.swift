//
//  Double.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/16/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import Foundation


public extension Double {

    public func currencyString() -> String{
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0;
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: NSNumber(value: self))
        return result!
    }
}
