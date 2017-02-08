//
//  WalkthroughPageViewController.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/7/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    
    var pageHeadings = ["Heading1", "Heading2", "Heading3"]
    var pageImages = ["red-lights-lisbon", "summer-beach-huts", "taxis-nyc"]
    var pageContent = ["Exciting message1",
        "Exciting message2",
        "Exciting message3"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Set the data source to itself
        dataSource = self
        
        // Create the first walkthrough screen
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
       
            if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
                
                pageContentViewController.imageFile = pageImages[index]
                pageContentViewController.heading = pageHeadings[index]
                pageContentViewController.content = pageContent[index]
                pageContentViewController.index = index
                
                return pageContentViewController
        }
        
        return nil
    }
    
    
    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageHeadings.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            
            return pageContentViewController.index
        }
        
        return 0
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
