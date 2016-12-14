//
//  Location.swift
//  LetsEat
//
//  Created by Patrice white on 12/14/16.
//  Copyright © 2016 Patrice white. All rights reserved.
//

import Foundation

class Location : NSObject{
    
    //properties
    
    var name: String?
    var latitude: String?
    var longitude: String?
    var open: String?
    var close: String?
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, @longitude, @open, & @close parameters
    
    init(name: String,latitude: String, longitude: String, open: String, close: String) {
        
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.open = open
        self.close = close
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(name), Latitude: \(latitude), Longitude: \(longitude), Open: \(open), Close: \(close)"
        
    }
    
}

