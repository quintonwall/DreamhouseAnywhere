//
//  InterfaceController.swift
//  DreamhouseAnywhereWatch Extension
//
//  Created by QUINTON WALL on 2/23/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import WatchKit
import Foundation




//Display a list of properties. We received these properties from app context updates from the phone
class InterfaceController: WKInterfaceController {

    

    @IBOutlet var tableView: WKInterfaceTable!
    
   
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        if let properties = UserDefaults.standard.array(forKey: "properties-list") {
            tableView.setNumberOfRows(properties.count, withRowType: "PropertyRowType")
            var index = 0
            
            for property in properties  {
                var p = property as? [String : String]
                if let controller = tableView.rowController(at: index) as? PropertyTableRow {
                    controller.priceLabel.setText(p?["price"])
                    controller.propertyId = p?["price"]
                    controller.propertyImage.setImageWithUrl(url: (p?["photo"]!)!, scale: 1.0)
                }
                index += 1
            }
        }
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
