//
//  PropertyData.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/3/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import Foundation
import SwiftlySalesforce



public struct PropertyData {
    
    public static let shared = PropertyData()

    public func getAllProperties() -> Promise<[Property]> {
        
        return Promise<[Property]> {
            fulfill, reject in
            
            first {
                salesforce.identity()
            }.then { result in
                let soql = "SELECT Id, Title__c, Price__c, Status__c, Picture__c, Description__c FROM Property__c"
                return salesforce.query(soql: soql)
            }.then {
                (result: QueryResult) -> () in
                let properties = result.records.map { Property(dictionary: $0) }
                fulfill(properties)
            }.catch {
                error in
                reject(error)
            }
            
        }
    }
    
    
}
