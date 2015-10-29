//
//  FavoritesTableViewController.swift
//  Wasei
//
//  Created by Chris Kong on 10/23/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating
{
  var places: [Place] = []
  var searchController: UISearchController!
  var searchResults: [Place] = []
  var fetchResultController: NSFetchedResultsController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Remove the title of the back button
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    // Enable self sizing cells
    tableView.estimatedRowHeight = 36.0
    tableView.rowHeight = UITableViewAutomaticDimension
  
    // Fetch request
    let fetchRequest = NSFetchRequest(entityName: "Place")
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    {
      fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      fetchResultController.delegate = self
      
      do {
        try fetchResultController.performFetch()
        places = fetchResultController.fetchedObjects as! [Place]
      } catch {
        print(error)
      }
    }
    
    // Adding a search bar
    searchController = UISearchController(searchResultsController: nil)
    tableView.tableHeaderView = searchController.searchBar
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    
    // Customize the appearance of the search bar
    searchController.searchBar.placeholder = "Search places..."
    searchController.searchBar.tintColor = UIColor.whiteColor()
    searchController.searchBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    
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
    if searchController.active
    {
      return searchResults.count
      
    } else {
      
      return places.count
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cellIdentifier = "Cell"
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FavoritesTableViewCell
    
    // configure for search bar
    let place = (searchController.active) ? searchResults[indexPath.row] : places[indexPath.row]
    
    // configure the cell
    cell.nameLabel.text = place.name
    cell.addressLabel.text = place.address
    cell.typeLabel.text = place.type
    cell.thumbnailImageView.image = UIImage(data: place.image!)
    
    return cell
  }

  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
  {
    if editingStyle == .Delete
    {
      // Delete the row from the data source
      places.removeAtIndex(indexPath.row)
    }
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  }
  
  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
  {
    // Social Sharing Button
    let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: { (action, indexPath) -> Void in
      
      let defaultText = " " + self.places[indexPath.row].name
      
      if let imageToShare = UIImage(data: self.places[indexPath.row].image!)
      {
        let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
      }
    })
    
    // Delete button
    let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action, indexPath) -> Void in
      
      // to remove
      // Delete the row from the data source
      self.places.removeAtIndex(indexPath.row)
      self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:
        .Fade)
      
      // Delete the row from the database
      if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
      {
        let placeToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Place
        managedObjectContext.deleteObject(placeToDelete)
        
        do {
          try managedObjectContext.save()
        } catch {
          print(error)
        }
      }
    })
    
    // Set the button color
    shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
    deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
    
    return [deleteAction, shareAction]
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
  {
    if searchController.active
  {
    return false
    
  } else {
    return true
    }
  }
  
  // MARK: - NSFetchedResultsControllerDelegate
  
  func controllerWillChangeContent(controller: NSFetchedResultsController)
  {
    tableView.beginUpdates()
  }
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
    switch type
    {
  case .Insert:
      if let _newIndexPath = newIndexPath
    {
      tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
    }
  case .Delete:
      if let _indexPath = indexPath
      {
      tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
    }
  case .Update:
        if let _indexPath = indexPath
      {
      tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
    }
  default:
        tableView.reloadData()
    }
    places = controller.fetchedObjects as! [Place]
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
    tableView.endUpdates()
  }
  
  // MARK: - Search
  
  func updateSearchResultsForSearchController(searchController: UISearchController)
  {
    if let searchText = searchController.searchBar.text
  {
    filterContentForSearchText(searchText)
    tableView.reloadData()
    }
  }
  
  func filterContentForSearchText(searchText: String)
    {
    searchResults = places.filter({ (place: Place) -> Bool in
    let nameMatch = place.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
    let addressMatch = place.address.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
    
    return nameMatch != nil || addressMatch != nil
    })
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == "showDetails"
    {
      if let indexPath = tableView.indexPathForSelectedRow
      {
        let destinationController = segue.destinationViewController as! DetailsViewController
        destinationController.place = (searchController.active) ? searchResults[indexPath.row] : places[indexPath.row]
      }
    }
  }

  
}