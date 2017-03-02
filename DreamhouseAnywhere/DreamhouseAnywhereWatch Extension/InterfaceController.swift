//
//  InterfaceController.swift
//  DreamhouseAnywhereWatch Extension
//
//  Created by QUINTON WALL on 2/23/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import WatchKit
import Foundation



class InterfaceController: WKInterfaceController {

    @IBOutlet var tableView: WKInterfaceTable!
    
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        fetchProperties()
        
        // Configure interface objects here.
    }
    
    
    func fetchProperties() {
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        //let property = properties[rowIndex]
        //presentController(withName: "PropertyDetails", context: property)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
