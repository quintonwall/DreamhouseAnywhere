//
//  PropertiesTableViewController.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/7/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit
import DreamhouseKit
import SwiftlySalesforce
import WatchConnectivity






class PropertiesTableViewController: UITableViewController, MenuTransitionManagerDelegate {
    
    let menuTransitionManger = MenuTransitionManager()
    var properties : [Property] = []
  
    var selectedProperty : Property!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        //cant use selectedRowAtIndex because it messes up the double tap in our cell
        let doubletaps = UITapGestureRecognizer(target: self, action: #selector(doubleTapDetected))
        doubletaps.numberOfTapsRequired = 2
        self.tableView.addGestureRecognizer(doubletaps)
        
        let singletap = UITapGestureRecognizer(target: self, action: #selector(singleTapDetected))
        singletap.numberOfTapsRequired = 1
        singletap.require(toFail: doubletaps) //otherwidr singletap always gets called.
        self.tableView.addGestureRecognizer(singletap)
        
        
        
        if(UserDefaults.standard.bool(forKey: "hasViewedWalkthrough")) {
            fetchProperties()
            return
        }

        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController {
            
            present(pageViewController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Salesforce data
    
    func fetchProperties() {
        first {
            PropertyData.shared.getAllProperties(salesforce: salesforce, simplytics: simplytics)
            
        }.then {
                (results) -> () in
                self.properties = results
                self.sendPropertiesToWatch()
                self.tableView.reloadData()
        }.catch {
         (error) -> () in
            print("error: \(error)")  //todo: handle this better
        }
        
        
    }
    func sendPropertiesToWatch() {
        let session = WCSession.default()
        if session.isWatchAppInstalled {
            do {
                var payload = [String : Any]()

                print("sending \(properties.count) records to watch")
                
                //TODO: I can probably clean this up...its kinda inefficient, but watchkit is kind of annoying at times, 
                //with its ability to only pass primivate types and some funcs taking [String:Any], but then the
                //next leg in the lifecycle it only takes [Any]... oh well, it's friday. take a chill pill
                for p: Property in properties {
                    payload[p.id] = p.getPropertyForWatchTransfer()
                }
                //note: if payloads stop getting received by watch, it is because watchconnectivity has
                // the 'smarts' to not resend the same payload that has been successfully processed. It makes sense,
                // but is a pain during dev. To reset just send a dummy payload like ["hello" : "quinton"]
                //and it will start working again.. 
                try session.updateApplicationContext(payload)
            } catch {
                print("ERROR: \(error)")
            }
        }
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return properties.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PropertiesTableViewCell
        
        let property : Property = properties[indexPath.row]
        cell.property = property
        cell.propertyImageURLString = property.propertyImageURLString
        cell.numBathrooms.text = "\(property.baths)"
        cell.price.text = property.price.currencyString()
        cell.numBedrooms.text = "\(property.baths)"
        
        return cell
    }
    
    func singleTapDetected(sender : UITapGestureRecognizer) {
        let cell = getCellFromTap(sender: sender)
        selectedProperty = cell.property
        simplytics.logEvent("Property selected", funnel: "View Property", withProperties: ["Property Id": cell.property.id, "From Screen" : "Properties Table View]"])
        simplytics.writeToSalesforce(salesforce)
        performSegue(withIdentifier: "propertydetails", sender: self)
    }
    
    func doubleTapDetected(sender: UITapGestureRecognizer) {
        let cell = getCellFromTap(sender: sender)
        cell.doubleTappedForFavorite()
        //sendFavoriteToWatch(property: cell.property)
     }
    
    private func getCellFromTap(sender: UITapGestureRecognizer) -> PropertiesTableViewCell {
        let position: CGPoint =  sender.location(in: self.tableView)
        let indexPath: IndexPath = self.tableView.indexPathForRow(at: position)!
        let cell = tableView.cellForRow(at: indexPath) as? PropertiesTableViewCell
        
        return cell!
    }
    
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let sourceController = segue.source as! MenuTableViewController
        self.title = sourceController.currentItem
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "propertydetails" {
            let detailsController = segue.destination as! PropertyDetailsViewController
            detailsController.property = selectedProperty
        } else if segue.identifier == "mapview" {
            let mapController = segue.destination as! MapBoxViewController
            mapController.properties = properties
        }
        
    }
 

}

// MARK: - Watch Connectivity
extension PropertiesTableViewController {
   
    
}







