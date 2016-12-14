//
//  Connection.swift
//  LetsEat
//
//  Created by Patrice white on 12/14/16.
//  Copyright © 2016 Patrice white. All rights reserved.
//

import Foundation

protocol ConnectionProtocal: class {
    func itemsDownloaded(items: NSArray)
}

class Connection: NSObject, URLSessionDataDelegate {
    
    //properties
    
    weak var delegate: ConnectionProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    //Set up URL request
    let urlPath: String = "http://10.222.1.203:8888/service.php"
        
    func downloadItems() {
        
        //Set up session/ start data retrival process
        let url: NSURL = NSURL(string: urlPath)!
        var session: URLSession!
        let configuration = URLSessionConfiguration.default
        
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        // make the request
        let task = session.dataTask(with: url as URL)
        
        task.resume()
        
    }
    
    //adds data to NSMutable data as it is recieved
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data);
        
    }
    
    // check to see if data was recieved
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
            self.parseJSON()
        }
    }
    
    func parseJSON() {
        
        //parsing JSON file
        var jsonFixer: NSArray = NSArray()
        var jsonResult: NSMutableArray = NSMutableArray()
        
        //Go through file and store objects in dictionary object
        do{
            jsonFixer = try JSONSerialization.jsonObject(with: self.data as Data, options: .allowFragments) as! NSArray
            jsonResult = NSMutableArray(array: jsonFixer)
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        let locations: NSMutableArray = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let location = Location()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let name = jsonElement["Name"] as? String,
                let latitude = jsonElement["Latitude"] as? String,
                let longitude = jsonElement["Longitude"] as? String,
                let open = jsonElement["Open"] as? String,
                let close = jsonElement["Close"] as? String
                
            {
            //adds the current location object to a mutable array
                location.name = name
                location.latitude = latitude
                location.longitude = longitude
                location.open = open
                location.close = close
                
            }
            
            locations.add(location)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: locations)
            
        })
    }
}
