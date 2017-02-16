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
    public var beds: Int = 0
    public var baths: Int = 0
    public var propertyImageURLString = ""
    public var thumbnailImageURLString = ""
    public var isSold: Bool = false
    public var address : Address?
    
    public init() {}
    
    
    //take JSON from Salesforce REST API and convert to strongly typed object
    public init(dictionary: [String: Any]) {
        for(key, value) in dictionary {
            switch key.lowercased() {
                case "id":
                    self.id = (value as? String)!
                case "title__c":
                    self.title = (value as? String)!
            case "baths__c":
                self.baths = (value as? Int)!
            case "beds__c":
                self.beds = (value as? Int)!
                case "description__c":
                    self.description = (value as? String)!
                case "picture__c":
                    self.propertyImageURLString = (value as? String)!
            case "thumbnail__c":
                self.thumbnailImageURLString = (value as? String)!
                case "price__c":
                    self.price = (value as? Double)!
                default:
                    continue
            }
        }
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
