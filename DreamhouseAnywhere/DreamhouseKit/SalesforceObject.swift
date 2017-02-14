//
//  SalesforceObject.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/14/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import Foundation


import Foundation

class SalesforceObject: NSObject {
    
    class func getType(sfdcid: NSString) -> String {
        var type: String
        
        if  sfdcid.hasPrefix("006")  {
            type = "Opportunity"
        }
        else {
            type = "Unknown"
        }
        
        return type
    }
    
    class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}
