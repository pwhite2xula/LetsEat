//
//  AllViewController.swift
//  LetsEat
//
//  Created by Patrice white on 12/14/16.
//  Copyright © 2016 Patrice white. All rights reserved.
//

import UIKit

class AllViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ConnectionProtocal {

    //Properties
    
    var feedItems: NSArray = NSArray()
    var selectedLocation : Location = Location()
    @IBOutlet weak var listRest: UITableView!
    @IBOutlet weak var rText: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set delegates and initialize Connection
        
        self.listRest.delegate = self
        self.listRest.dataSource = self
        
        let connect = Connection()
        connect.delegate = self
        connect.downloadItems()
    }
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        self.listRest.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "cell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: Location = feedItems[indexPath.row] as! Location
        // Get references to labels of cell
        myCell.textLabel?.text = item.description
        
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set selected location to var
        selectedLocation = feedItems[indexPath.row] as! Location
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "allMapSegue", sender: self)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get reference to the destination view controller
        let detailVC  = segue!.destination as! ShowAllViewController
        // Set the property to the selected location so when the view for
        // detail view controller loads, it can access that property to get the feeditem obj
        detailVC.selectedLocation = selectedLocation
    }
}
