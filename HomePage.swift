//
//  HomePage.swift
//  LetsEat
//
//  Created by Patrice white on 11/29/16.
//  Copyright © 2016 Patrice white. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomePage: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate{
    

    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet weak var map: MKMapView!
    // shows search bar
    @IBAction func showSearchBar(_ sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        //placeCoordinates()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePage.dismissKeyboard))
        view.addGestureRecognizer(tap)
 
    }
    
    //gets user location
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        print(location.altitude)
        print(location.speed)
        
        self.map.showsUserLocation = true
    }
 
        
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //dismiss search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.map.annotations.count != 0{
            annotation = self.map.annotations[0]
            //self.map.removeAnnotation(annotation)
        }
        
        //Search for address
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //Place pin for address
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.map.centerCoordinate = self.pointAnnotation.coordinate
            self.map.addAnnotation(self.pinAnnotationView.annotation!)
        }
        
    }
    
    
    var Resturants:[(lat:String, lon:String, name:String)]?
    //var dicRest = [String:String]()
    //var arryRest = NSMutableArray()
    
    func placeCoordinates(){
        
         let fPath = Bundle.main.path(forResource: "Coordinates", ofType: "txt")
        
        let fManager = FileManager.default
        if fManager.fileExists(atPath: fPath!){
            do {

                let fullText = try String(contentsOfFile: fPath!, encoding: String.Encoding.utf8)
                let readings:[String] = fullText.components(separatedBy: "\n") as[String]
                
                self.Resturants = []
                
                for i in 1..<readings.count{

                    let restData = readings[i].components(separatedBy: "\t")
                    
                    let rest = (lat:restData[0], lon:restData[1], name:restData[2])
                    self.Resturants?.append(rest)
                    
                    
                    
                    self.pointAnnotation = MKPointAnnotation()
                    self.pointAnnotation.title = rest.name
                    self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(rest.lat)!, longitude: Double(rest.lon)!)
                    
                    self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                    self.map.centerCoordinate = self.pointAnnotation.coordinate
                    self.map.addAnnotation(self.pinAnnotationView.annotation!)
                }
            }catch{
                print("There is an error")
            }
        }
        
    }
}
