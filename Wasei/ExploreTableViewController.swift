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
  @IBOutlet var spinner: UIActivityIndicatorView!
 
  var places: [CKRecord] = []
  var imageCache: NSCache = NSCache()
  
  // var searchController: UISearchController!
  // var searchResults: [Place] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    spinner.hidesWhenStopped = true
    spinner.center = view.center
    view.addSubview(spinner)
    spinner.startAnimating()
    
    getRecordsFromCloud()
    
    // Pull To Refresh Control
    refreshControl = UIRefreshControl()
    refreshControl?.backgroundColor = UIColor.whiteColor()
    refreshControl?.tintColor = UIColor.grayColor()
    refreshControl?.addTarget(self, action: "getRecordsFromCloud", forControlEvents: UIControlEvents.ValueChanged)
    
    
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
  
  // MARK: - CloudKit
  
  func getRecordsFromCloud()
  {
    // Fetch data using Convenience API
    let cloudContainer = CKContainer.defaultContainer()
    let publicDatabase = cloudContainer.publicCloudDatabase
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Place", predicate: predicate)
    // to update
    query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.desiredKeys = ["name", "type", "neighborhood"]
    queryOperation.queuePriority = .VeryHigh
    queryOperation.resultsLimit = 50
    queryOperation.recordFetchedBlock = { (record: CKRecord!) -> Void in
      if let placeRecord = record
      {
        self.places.append(placeRecord)
      }
    }
    
    queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
      if (error != nil)
      {
        print("Failed to get data from iCloud - \(error!.localizedDescription)")
        return
      }
      
      print("Successfully retrieve the data from iCloud")
      self.refreshControl?.endRefreshing()
      
      NSOperationQueue.mainQueue().addOperationWithBlock()
      {
        self.spinner.stopAnimating()
        self.tableView.reloadData()
      }
    }
    // Clear array
    places.removeAll()
    
    // Execute the query
    publicDatabase.addOperation(queryOperation)
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
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ExploreTableViewCell
    
    // Configure the cell..
    let place = places[indexPath.row]
    cell.nameLabel.text = place.objectForKey("name") as? String
    cell.typeLabel.text = place.objectForKey("type") as? String
    cell.neighborhoodLabel.text = place.objectForKey("neighborhood") as? String
    
    // Set default image
    cell.bgImageView.image = nil
    
    // Check if the image is stored in cache
    if let imageFileURL = imageCache.objectForKey(place.recordID) as? NSURL
    {
      // Fetch image from cache
      print("Get image from cache")
      cell.bgImageView.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
    
    } else {
      
      // Fetch Image from Cloud in background
      let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
      let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [place.recordID])
      fetchRecordsImageOperation.desiredKeys = ["image"]
      fetchRecordsImageOperation.queuePriority = .VeryHigh
      
      fetchRecordsImageOperation.perRecordCompletionBlock = { (record: CKRecord?, recordID: CKRecordID?, error: NSError?) -> Void in
        if (error != nil)
      {
        print("Failed to get place image: \(error!.localizedDescription)")
        return
      }
      
        if let placeRecord = record
        {
          NSOperationQueue.mainQueue().addOperationWithBlock()
          {
            if let imageAsset = placeRecord.objectForKey("image") as? CKAsset
            {
              cell.bgImageView.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
            
              // Add the image URL to cache
              self.imageCache.setObject(imageAsset.fileURL, forKey: place.recordID)
            }
          }
        }
      }
      publicDatabase.addOperation(fetchRecordsImageOperation)
    }
    return cell
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
  
  // MARK: - Navigation
  
  @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue)
  {
  }

}