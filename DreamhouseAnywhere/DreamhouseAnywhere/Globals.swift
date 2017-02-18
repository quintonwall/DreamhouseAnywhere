//
//  Globals.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/17/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import Foundation
import UIKit
import ServiceSOS
import ServiceCore


public class Globals {
    
    static func getSOSOptions() -> SOSOptions {
        let options = SOSOptions(liveAgentPod: "d.la4-c1-was.salesforceliveagent.com",
                                 orgId: "00D36000000kFKB",
                                 deploymentId: "0NW36000000Gmxc")
        
        options?.featureClientFrontCameraEnabled = true
        options?.featureClientBackCameraEnabled = true
        //options.initialCameraType = SOSCameraType.FrontFacing
        options?.featureClientScreenSharingEnabled = true
        
        return options!
    }
}

public struct ColorPallete {
    public let flatMustard = UIColor(hex: "EBDE8E")
    public let flatGreen = UIColor(hex: "415450")
    public let lightGrey = UIColor(hex: "D0D4D3")
    public let darkGrey = UIColor(hex: "A4A9A6")
    public let flatSalmon = UIColor(hex: "D08788")
    
    init() {}
}
   
