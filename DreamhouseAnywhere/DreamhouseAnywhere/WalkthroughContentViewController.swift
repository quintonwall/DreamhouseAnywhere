//
//  WalkthroughContentViewController.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/7/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit
import Spring
import SwiftlySalesforce


class WalkthroughContentViewController: UIViewController {
    
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet weak var getStartedButton: SpringButton!
   
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pageControl.currentPage = index
        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStartedButtonTapped(_ sender: Any) {
    
        getStartedButton.animation = "pop"
        getStartedButton.animate()
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        
        //now they have viewed the walkthrough, we can enable 3D touch shortcuts
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            let bundleIdentifier = Bundle.main.bundleIdentifier
            let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenFavorites", localizedTitle: "Show Favorites", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "favorite-shortcut"), userInfo: nil)
            let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenDiscover", localizedTitle: "Nearby Listings", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "discover-shortcut"), userInfo: nil)
            UIApplication.shared.shortcutItems = [shortcutItem1, shortcutItem2]
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
