//
//  PropertyDetailsViewController.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/17/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit
import DreamhouseKit
import MapKit
import SDWebImage
import ServiceCore
import ServiceSOS
import SwiftlySalesforce



class PropertyDetailsViewController: UIViewController, SOSDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var propertyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var agentImageView: UIImageView!
    @IBOutlet weak var agentNameLabel: UILabel!
    @IBOutlet weak var liveChatButton: UIButton!
    @IBOutlet weak var getPreApprovedButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numFavoritesLabel: UILabel!
    @IBOutlet weak var numBedsLabel: UILabel!
    @IBOutlet weak var numBathsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var recommendedPropertiesCollectionView: UICollectionView!
    
    @IBOutlet weak var featuresInfoView: UIView!
    
    let regionRadius: CLLocationDistance = 150
    var propertyLocation : CLLocation?
    let locationManger:CLLocationManager = CLLocationManager()
    
      var recProperties : [Property] = []
    
    var property : Property!

    override func viewDidLoad() {
        super.viewDidLoad()
        SCServiceCloud.sharedInstance().sos.add(self)
        
        
        
        agentImageView.makeRoundWithBorder(width: 1, color: ColorPallete().flatGreen)
        mapView.makeRoundWithBorder(width: 1, color: ColorPallete().flatGreen)
        
        featuresInfoView.layer.borderWidth = 0.5
        featuresInfoView.layer.borderColor = ColorPallete().lightGrey.cgColor

        if ( property != nil) {
            propertyImageView.sd_setImage(with: URL(string: property.propertyImageURLString))
            titleLabel.text = property.title
            agentImageView.sd_setImage(with: URL(string: property.brokerImageURL))
            agentNameLabel.text = property.brokerName
            descriptionLabel.text = property.description
            numBedsLabel.text = "\(property.beds)"
            numBathsLabel.text = "\(property.baths)"
            priceLabel.text = property.price.currencyString()
            
            propertyLocation = CLLocation(latitude: self.property!.latitude, longitude: self.property!.longitude)
            centerMapOnLocation(location: propertyLocation!)

        }
        
        recommendedPropertiesCollectionView.delegate = self
        recommendedPropertiesCollectionView.dataSource = self
        fetchRecommendations()
    }

    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = location.coordinate
        objectAnnotation.title = property?.title
        self.mapView.addAnnotation(objectAnnotation)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func liveAgentTapped(_ sender: Any) {
        SCServiceCloud.sharedInstance().sos.startSession(with: Globals.getSOSOptions())
    }
    
    // MARK: - Salesforce
    func fetchRecommendations() {
        first {
            PropertyData.shared.getRecommendedProperties()
            
            }.then {
                (results) -> () in
                self.recProperties = results
                self.recommendedPropertiesCollectionView.reloadData()
            }.catch {
                (error) -> () in
                print("error: \(error)")  //todo: handle this better
        }
    }

    
    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recProperties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recommendedPropertiesCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RecommendPropertiesCollectionViewCell
        
        let property : Property = recProperties[indexPath.row]
        cell.property = property
        cell.propertyImageURLString = property.propertyImageURLString
        return cell
        
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
