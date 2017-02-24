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
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    
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
            PropertyData.shared.getAllProperties()
            
        }.then {
                (results) -> () in
                self.properties = results
                self.tableView.reloadData()
        }.catch {
         (error) -> () in
            print("error: \(error)")  //todo: handle this better
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
        performSegue(withIdentifier: "propertydetails", sender: self)
    }
    
    func doubleTapDetected(sender: UITapGestureRecognizer) {
        let cell = getCellFromTap(sender: sender)
        cell.doubleTappedForFavorite()
        sendFavoriteToWatch(property: cell.property)
        
        /*
        DispatchQueue.main.async { () -> Void in
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name(rawValue: NotificationPropertyFavoritedOnPhone), object: cell.property)
        }
 */
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
        }
        
    }
 

}

// MARK: - Watch Connectivity
extension PropertiesTableViewController {
    func sendFavoriteToWatch(property : Property){
        if WCSession.isSupported() {
            let session = WCSession.default()
            if session.isWatchAppInstalled {
              
                //let userInfo = ["favorite-id":property.id, "property":pr]
                session.transferUserInfo(property.asDictionary!)
            }
    
        }
    }
}







