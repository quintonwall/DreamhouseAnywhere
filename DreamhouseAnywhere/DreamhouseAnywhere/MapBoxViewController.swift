//
//  MapBoxViewController.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 6/2/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit
import Mapbox
import DreamhouseKit


class MapBoxViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!
    var properties : [Property] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        
        plotPropertyLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func plotPropertyLocations() {
        for p in properties {
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude)
            point.title = p.title
            point.subtitle = p.description
            
            mapView.addAnnotation(point)
        }
    }
    
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    // Or, if you’re using Swift 3 in Xcode 8.0, be sure to add an underscore before the method parameters:
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
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
