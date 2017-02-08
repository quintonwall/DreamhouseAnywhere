//
//  PropertiesTableViewController.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/7/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit
import DreamhouseKit

class PropertiesTableViewController: UITableViewController, MenuTransitionManagerDelegate {
    
    let menuTransitionManger = MenuTransitionManager()
    let properties = PropertyData.propertySet
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if(UserDefaults.standard.bool(forKey: "hasViewedWalkthrough")) {
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
        cell.hotPropertyImageView.image = UIImage(named: property.mainImageName)
        cell.shortTitle.text = property.title
        cell.price.text = "$\(property.price)"
        cell.longDescription.text = property.description
        
        return cell
    }

    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let sourceController = segue.source as! MenuTableViewController
        self.title = sourceController.currentItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menuTableViewController = segue.destination as! MenuTableViewController
        menuTableViewController.currentItem = self.title!
        menuTransitionManger.delegate = self
        menuTableViewController.transitioningDelegate = menuTransitionManger
        
    }

}
