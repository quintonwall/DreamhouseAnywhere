
//
//  MenuTableViewController.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/7/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit
import SwiftlySalesforce
import DreamhouseKit

class MenuTableViewController: UITableViewController {

    var menuItems = ["Home", "For Sale", "Recommended", "Favorites", "How to Save Trail", "Store", "Settings", "About", "Logout"]
    var currentItem = "Home"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell

        // Configure the cell...
        cell.titleLabel.text = menuItems[indexPath.row]
        cell.titleLabel.textColor = (menuItems[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray

        return cell
    }
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MenuTableViewCell
        let whichpage = menuItems[indexPath.item]
        switch whichpage.lowercased() {
            case "logout":
                logout()
            default:
                break
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menuTableViewController = segue.source as! MenuTableViewController
        if let selectedIndexPath = menuTableViewController.tableView.indexPathForSelectedRow {
            currentItem = menuItems[selectedIndexPath.row]
        }
    }
    
    private func logout() {
    // Call this when your app's "Log Out" button is tapped, for example
        if let app = UIApplication.shared.delegate as? LoginDelegate {
            app.logout().then {
                () -> () in
                // Clear any cached data and reset the UI
                PropertyData.shared.clear()
                    UserDefaults.standard.removeObject(forKey: "hasViewedWalkthrough")
                return
                }.catch {
                    error in
                    debugPrint(error)
            }
        }
    }
}
