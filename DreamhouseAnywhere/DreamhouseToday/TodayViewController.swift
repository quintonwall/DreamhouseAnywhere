//
//  TodayViewController.swift
//  DreamhouseToday
//
//  Created by QUINTON WALL on 2/3/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit
import NotificationCenter
//import DreamhouseKit
//import SwiftlySalesforce


class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var numListingsLabel: UILabel!
    @IBOutlet weak var numFavoritesLabel: UILabel!
    
    //var properties : [Property] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
       // fetchProperties()
    }
    
    /*
    func fetchProperties() {
        first {
            PropertyData.shared.getPublicPropertyListings()
            
            }.then {
                (results) -> () in
                self.properties = results
                self.numListingsLabel.text = "\(self.properties.count)"
            }.catch {
                (error) -> () in
                print("error: \(error)")  //todo: handle this better
        }
        
        
    }
 */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
