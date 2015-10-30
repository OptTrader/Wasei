//
//  ExploreTableViewController.swift
//  Wasei
//
//  Created by Chris Kong on 10/23/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CloudKit

class ExploreTableViewController: UITableViewController
  //, UISearchResultsUpdating
{
  var places: [CKRecord] = []
  // var searchController: UISearchController!
  // var searchResults: [Place] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getRecordsFromCloud()
    
    // Adding a search bar
//    searchController = UISearchController(searchResultsController: nil)
//    tableView.tableHeaderView = searchController.searchBar
//    // searchController.searchResultsUpdater = self
//    searchController.dimsBackgroundDuringPresentation = false
//    
//    // Customize the appearance of the search bar
//    searchController.searchBar.placeholder = "Search places..."
//    searchController.searchBar.tintColor = UIColor.whiteColor()
//    searchController.searchBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    
  }

  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
    
    if hasViewedWalkthrough
    {
      return
    }
    
    if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughController") as? WalkthroughPageViewController
    {
      presentViewController(pageViewController, animated: true, completion: nil)
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.hidesBarsOnSwipe = true
  }
  
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return places.count
    
//    if searchController.active
//    {
//      return searchResults.count
//      
//    } else {
//      
//      return places.count
//    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    
    // Configure the cell..
    let place = places[indexPath.row]
    cell.textLabel?.text = place.objectForKey("name") as? String
    
    if let image = place.objectForKey("image")
    {
      let imageAsset = image as! CKAsset
      cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
    }
    
    return cell
  }
  
  // MARK: - CloudKit
  
  func getRecordsFromCloud()
  {
    // Fetch data using Convenience API
    let cloudContainer = CKContainer.defaultContainer()
    let publicDatabase = cloudContainer.publicCloudDatabase
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Place", predicate: predicate)
    publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: {
      (results, error) -> Void in
      
      if error != nil
      {
        print(error)
        return
      }
      
      if let results = results
      {
        self.places = results
        
        NSOperationQueue.mainQueue().addOperationWithBlock()
        {
          self.tableView.reloadData()
        }
        
      }
      
    })
  }
  
  // MARK: - Search
//  
//  func updateSearchResultsForSearchController(searchController: UISearchController)
//  {
//    if let searchText = searchController.searchBar.text
//    {
//      filterContentForSearchText(searchText)
//      tableView.reloadData()
//    }
//  }
//
//  func filterContentForSearchText(searchText: String)
//  {
//    searchResults = places.filter({ (place: Place) -> Bool in
//      let nameMatch = place.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//      let addressMatch = place.address.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//      
//      return nameMatch != nil || addressMatch != nil
//    })
//  }
  
  
  @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue)
  {
  }
  


}