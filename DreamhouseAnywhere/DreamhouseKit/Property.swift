//
//  Property.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/3/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import Foundation


public struct Property {
    public var id: String = ""
    public var title: String = ""
    public var description: String = ""
    public var price: Double = 0.0
    public var isSold: Bool = false
    public var address : Address?
    public var mainImageName : String = ""
    
    public init(id: String, title: String, description: String, price: Double, isSold: Bool, address: Address, mainImageName: String) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.isSold = isSold
        self.address = address
        self.mainImageName = mainImageName
        
    }
    
}



public struct Address {
    public var street: String = ""
    public var city: String = ""
    public var state: String = ""
    public var zip: String = ""
    public var long: String = ""
    public var lat: String = ""
    
    public init(street: String, city: String, state: String, zip: String, long: String, lat: String) {
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.long = long
        self.lat = lat
    }
}
