//
//  ShowAllViewController.swift
//  LetsEat
//
//  Created by Patrice white on 12/14/16.
//  Copyright © 2016 Patrice white. All rights reserved.
//

import UIKit
import MapKit

class ShowAllViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
     var selectedLocation : Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Create coordinates from location lat/long
        var poiCoodinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        poiCoodinates.latitude = CDouble((self.selectedLocation?.latitude)!)!
        poiCoodinates.longitude = CDouble((self.selectedLocation?.longitude)!)!
        
        // Zoom to region
        let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(poiCoodinates, 750, 750)
        self.mapView.setRegion(viewRegion, animated: true)
        // Plot pin
        let pin: MKPointAnnotation = MKPointAnnotation()
        pin.coordinate = poiCoodinates
        self.mapView.addAnnotation(pin)
        
        //add title to the pin
        pin.title = selectedLocation?.name
        
    }
    

    
}
