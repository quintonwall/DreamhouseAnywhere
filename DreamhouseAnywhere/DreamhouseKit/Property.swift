//
//  Property.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/3/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import Foundation


//static let soqlGetAllProperties =  City__c, Description__c, Id, Location__c, Name, OwnerId, Picture__c, Price__c, State__c, Thumbnail__c, Title__c, Zip__c, (select id, Property__c from Favorites__r) from Property__c")



public struct Property {
    
    public var id: String = ""
    public var propertyImageURLString = ""
    public var thumbnailImageURLString = ""
    public var isSold: Bool = false
    public var address : Address?
    public var city: String = ""
    public var state: String = ""
    public var description: String = ""
    public var pictureImageURL: String = ""
    public var price:Double  = 0
    public var thumbnailImageURL: String = ""
    public var title: String?
    public var zip: String?
    public var baths: Int = 0
    public var beds: Int = 0
    public var longitude: Double = 0
    public var latitude: Double = 0
    public var isFavorite: Bool = false
    
    //broker info
    public var brokerId: String = ""
    public var brokerName: String = ""
    public var brokerTitle: String = ""
    public var brokerImageURL: String = ""
    
    //favorite
    public var favoriteId: String = ""
    
    //save dictionary representation as we need to pass that to watchos apps
    public var asDictionary: [String : Any]?
    
    public init() {}
    
    
    //take JSON from Salesforce REST API and convert to strongly typed object
    public init(dictionary: [String: Any]) {
        asDictionary = dictionary
        
        for(key, value) in dictionary {
            switch key.lowercased() {
                case "id":
                    self.id = (value as? String)!
                case "title__c":
                    self.title = (value as? String)!
                case "broker__c":
                    self.brokerId = (value as? String)!
                case "broker__r":
                    var payload: [String: Any] = value as! [String : Any]
                    for (key, value) in payload {
                        switch key.lowercased() {
                           case "title__c":
                            self.brokerTitle = (value as? String)!
                        case "name":
                            self.brokerName = (value as? String)!
                        case "picture__c":
                            self.brokerImageURL = (value as? String)!
                        default:
                            continue
                        }
                    }
                case "city__c":
                    self.city = (value as? String)!
                case "favorites__r":
                    self.isFavorite = true
                case "location__c":
                    var payload: [String: Any] = value as! [String : Any]
                    for (key, value) in payload {
                        switch key.lowercased() {
                            case "longitude":
                                self.longitude = (value as? Double)!
                        case "latitude":
                            self.latitude = (value as? Double)!
                        default:
                            continue
                        }
                    }
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
