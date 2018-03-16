//
//  Property.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/3/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import Foundation




//static let soqlGetAllProperties =  City__c, Description__c, Id, Location__c, Name, OwnerId, Picture__c, Price__c, State__c, Thumbnail__c, Title__c, Zip__c, (select id, Property__c from Favorites__r) from Property__c")

public struct Broker: Decodable {
    
    public var id: String = ""
    public var brokerName: String = ""
    public var brokerTitle: String = ""
    public var brokerImageURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case brokerName = "Name"
        case brokerTitle = "Title__c"
        case brokerImageURL = "Picture__c"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        brokerName = try values.decode(String.self, forKey: .brokerName)
        brokerTitle = try values.decode(String.self, forKey: .brokerTitle)
        brokerImageURL = try values.decode(String.self, forKey: .brokerImageURL)
        
    }
    
}

public struct PropertyLocation: Decodable {
    
    public var longitude: Double = 0
    public var latitude: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case longitude = "longitude"
        case latitude = "latitude"
       
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        longitude = try values.decode(Double.self, forKey: .longitude)
        latitude = try values.decode(Double.self, forKey: .latitude)
    }
    
}

public struct Favorite: Decodable {
    
    public var id: String = ""
    public var PropertyId: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case property = "Property__c"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        PropertyId = try values.decode(String.self, forKey: .property)
    }
    
}


public final class Property : Decodable {
    
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
    
    //property geo
    public var proplocation : PropertyLocation?
    public var latitude: Double = 0
    public var isFavorite: Bool = false
    
    
    //broker info
    public var broker: Broker?
    public var brokerId: String = ""
    public var brokerName: String = ""
    public var brokerTitle: String = ""
    public var brokerImageURL: String = ""
    
    
    //save dictionary representation as we need to pass that to watchos apps
    public var asDictionary: [String : Any]?
    
    public init() {}
    
    //take SwiftlySalesforce record and map.
     enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title = "Title__c"
        
        case broker = "Broker__r"
        case proplocation = "Location__c"
        
        case city = "City__c"
        case favorites = "Favorites__r"
        
        case baths = "Baths__c"
        case beds = "Beds__c"
        case description = "Description__c"
        case propertyImageURLString = "Picture__c"
        case thumbnailImageURLString = "Thumbnail__c"
        case price = "Price__c"
        
    }
    
    required public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
         city = try values.decode(String.self, forKey: .city)
       // var favs = try values.decode(Favorite.self, forKey: .favorites)
        //todo: loop through favs and flag as isFavorite if I find a match
        
        broker  = try values.decode(Broker.self, forKey: .broker)
        brokerId = broker!.id
        brokerName = broker!.brokerName
        brokerTitle = broker!.brokerTitle
        brokerImageURL = broker!.brokerImageURL
        
        //location
        proplocation = try values.decode(PropertyLocation.self, forKey: .proplocation)
        longitude = proplocation!.longitude
        latitude = proplocation!.latitude
        
        baths = try values.decode(Int.self, forKey: .baths)
        beds = try values.decode(Int.self, forKey: .beds)
        description = try values.decode(String.self, forKey: .description)
        propertyImageURLString = try values.decode(String.self, forKey: .propertyImageURLString)
        thumbnailImageURLString = try values.decode(String.self, forKey: .thumbnailImageURLString)
        price = try values.decode(Double.self, forKey: .price)
       
    }
    
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
    
    /**
     * WatchOS can only handle simple structure. let's cast down and only send what we need
     */
    public func getPropertyForWatchTransfer() -> [String : String] {
        var payload = [String : String]()
        payload["id"] = self.id
        payload["price"] = currencyString(d: self.price)
        payload["photo"] = self.propertyImageURLString
        
        return payload
    }
    
    func currencyString(d : Double) -> String{
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0;
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: NSNumber(value: d))
        return result!
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
