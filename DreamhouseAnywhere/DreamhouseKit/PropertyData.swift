//
//  PropertyData.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/3/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

//import Foundation
import SwiftlySalesforce
import Alamofire
import SwiftyJSON



public final class PropertyData {
    
    public static let shared = PropertyData()
    
    let recommendationServiceURLString = "http://dreamhouseany-pio-recserver.herokuapp.com/queries.json"
    
    public fileprivate(set) var cachedProperties : [Property]?

    public func getAllProperties() -> Promise<[Property]> {
        
        //let defaults = UserDefaults(suiteName: "group.com.quintonwall.dreamhouseanywhere")!
        //if let sfdcconfig = defaults.value(forKey: "saleforceconfig") as? AuthManager.Configuration {
        //    salesforce.authManager.configuration = sfdcconfig
        //}
        return Promise<[Property]> {
            fulfill, reject in
            first {
                      salesforce.identity()
                
            }.then { result in
                let soql = "select Address__c, Baths__c, Beds__c, Broker__c, Broker__r.Title__c, Broker__r.Name, Broker__r.Picture__c, City__c, Description__c, Id, Location__c, Name, OwnerId, Picture__c, Price__c, State__c, Thumbnail__c, Title__c, Zip__c, (select id, Property__c from Favorites__r) from Property__c"
                return salesforce.query(soql: soql)
            }.then {
                (result: QueryResult) -> () in
                let properties = result.records.map { Property(dictionary: $0) }
                self.cachedProperties = properties
                fulfill(properties)
            }.catch { error in
                reject(error)
            }
            
        }
    }
    
    
    /**
     * Example of using predictionIO recommendations.
     * See https://github.com/quintonwall/dreamhouse-pio/tree/salesforce-rest for the PIO service.
     * Unlike the PIO service for the main dreamhouse app, which relies on Heroku Connect to sync data to a Heroku Postgres instance (for the mobile web app to retrieve data from) and fetch favorites, the recommendation service
     * used in DreamhouseAnywhere fetches favorites directly from Salesforce via REST APIs. 
     */
    public func getRecommendedProperties(userid: String) -> Promise<[Property]> {
    
        return Promise<[Property]> {
            fulfill, reject in
            
                let theurl = URL(string: self.recommendationServiceURLString)
                let headers = ["Content-Type" : "application/json"]
                let params = ["userId" : userid, "numResults" : "10" ]
                
                var recommendations : [Property] = []
                
               Alamofire.request(theurl!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                        case .success(let json):
                           let res = json as? [String: Any]
                           let props = res?["propertyRatings"] as? [String: Any]
                           
                           //resonses come back with the sfdc propertyid as the key in the array.
                           //lets check the cache and pull from there to save another network call.
                           for(key, val) in props! {
                                for p in self.cachedProperties!  {
                                    print("cached prop id: \(p.id)")
                                    if (p.id == key) {
                                        recommendations.append(p)
                                        print("adding recommended property: \(key)")
                                    }
                                }
                           }
                           fulfill(recommendations)
                        case .failure(let error):
                            reject(error)
                    }
                }
        }
    }

    

    
    //
     // For many consumer app secenarios, we need to fetch data from salesforce anonymously. eg: a listing of properties, especially through bots etc.
     // The two patterns for acheiving this is either create a named user and connect from a service running on heroku, or expose a public function directly on salesforce.
    // Which one you should choose depends a lot on your use case. For example, for an amazon echo / alexa bot that requires some code to handle translating alexa skill commands to a force.com soql query,
    // it probably makes sense to write this in something like node as a microservice running on heroku. But if we are simply wanting to create an optimized API endpoint for salesforce data, 
    // ApexRest func is super fast and fully managed/secure with no additional work.
    // The other consideration should be load. Salesforce scales incredibly well, but it is not designed for elastic consumer scale. If you are targeting an app that millions of consumers will be accessing the data, you should deploy your service
    //on heroku, then use Heroku Connect to manage the connection to salesforce. That way you can leverage all the caching and batching intelligence that we put in HerokuConnect. :)
    //
    //  This func is an example of using a serverless function (called an ApexRest class in Salesforce terminology) to create a public endpoint and return a subset of property data. We want to use it from our iMessages app
    
     //
     // Steps to create the (first) function in the cloud (salesforce): (once you've set up the site, future ApexRest / Serverless function config, just requires step 1 and 4.
     //
     // 1. create a Apex class similar to this
     //   @RestResource(urlMapping='/PropertiesForSale/*')
     //   global class PublicProperties {
     //
     // @HttpGet
     //       global static List<Property__c> getProperties() {
     //           List<Property__c> properties = [SELECT Id, Title__c, Price__c, Status__c, Picture__c, Thumbnail__c, Description__c FROM Property__c];
     //           return properties;
     //       }
     //
     //   }
     //
     // 2. Set up a force.com sites endpoint (think of this as a service endpoint. We really just want to use it to allow us to create a profile for controlling access to public data and functions. I prefer to keep
     //  the config separate from a communities URL/Site. To me, an API service endpoint is different and likely managed differently
     //  > In Setup, search for Sites. Then create a site with a unique name. Something like myapp-api.xxx is good
     //  > Save the site and activate, then edit the Profile
     //
     // 3. In the profile, click edit then scroll down to the object your serverless function / ApexRest func accesses, and click all the checkboxes beside it. (unless of course, you just want readonly, then dont :P)
    //
     // 4. Keep scrolling down until you see a section titled " Enabled Apex Class Access" and add your ApexRest class.
     //
     // 5. Save and you are done!
     //
     // Anyway, on with the show...
     //
 public func getPublicPropertyListings() -> Promise<[Property]> {
    
    
    return Promise<[Property]> {
        fulfill, reject in
            Alamofire.request("https://publicdreamhouse-developer-edition.na30.force.com/api/services/apexrest/PropertiesForSale")
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let result):
                        let json = JSON(result)
                        var properties = [Property]()
                        
                        for (_,subJson):(String, JSON) in json {
                            properties.append(Property(dictionary: subJson.dictionaryObject!))
                        }
                        fulfill(properties)
                    case .failure(let error):
                            reject(error)
                    }
            }
        }
    }
    
    public func clear() {
        cachedProperties = nil
    }
    
}


