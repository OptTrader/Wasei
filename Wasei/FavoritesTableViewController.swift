//
//  FavoritesTableViewController.swift
//  Wasei
//
//  Created by Chris Kong on 10/23/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController
{

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return 1
    
//    if searchController.active
//    {
//      return searchResults.count
//      
//    } else {
//      return restaurants.count
//    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cellIdentifier = "Cell"
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
    
//    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RestaurantTableViewCell
//    
//    // configure for search bar
//    let restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
//    
//    // configure the cell
//    cell.nameLabel.text = restaurant.name
//    cell.locationLabel.text = restaurant.location
//    cell.typeLabel.text = restaurant.type
//    cell.thumbnailImageView.image = UIImage(data: restaurant.image!)
//    
//    if let isVisited = restaurant.isVisited?.boolValue
//    {
//      cell.accessoryType = isVisited ? .Checkmark : .None
//    }
    
    return cell
  }


  
}