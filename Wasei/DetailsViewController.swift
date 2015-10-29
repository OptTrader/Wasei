//
//  DetailsViewController.swift
//  Wasei
//
//  Created by Chris Kong on 10/26/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
  @IBOutlet weak var placeImageView: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var ratingButton: UIButton!
  
  var place: Place!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    placeImageView.image = UIImage(data: place.image!)
    
    // Change the color of the table view
    tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
    
    // Remove the separators of the empty rows
    tableView.tableFooterView = UIView(frame: CGRectZero)
    
    // Change the color of the separator
    tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
    
    // Set the title of the navigation bar
    title = place.name
    
    // Enable self sizing cells
    tableView.estimatedRowHeight = 36.0
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Set the rating of the restaurant
    if let rating = place.rating where rating != ""
    {
      ratingButton.setImage(UIImage(named: place.rating!), forState: UIControlState.Normal)
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.hidesBarsOnSwipe = false
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  
  // MARK: - Table view data source
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return 5
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DetailsTableViewCell
    
    // Configure the cell..
    switch indexPath.row
    {
      case 0:
        cell.fieldLabel.text = "Name"
        cell.valueLabel.text = place.name
      case 1:
        cell.fieldLabel.text = "Type"
        cell.valueLabel.text = place.type
      case 2:
        cell.fieldLabel.text = "Address"
        cell.valueLabel.text = place.address
      case 3:
        cell.fieldLabel.text = "Neighborhood"
        cell.valueLabel.text = place.neighborhood
      case 4:
        cell.fieldLabel.text = "Phone"
        cell.valueLabel.text = place.phoneNumber
      case 5:
        cell.fieldLabel.text = "Has Wifi?"
        if let hasWifi = place.hasWifi?.boolValue
        {
          cell.valueLabel.text = hasWifi ? "Yes, they have wifi" : "No"
        }
      case 6:
        cell.fieldLabel.text = "Has Baby Seats?"
        if let hasBabySeats = place.hasBabySeats?.boolValue
        {
          cell.valueLabel.text = hasBabySeats ? "Yes, they have baby seats" : "No"
        }
        
      default:
        cell.fieldLabel.text = ""
        cell.valueLabel.text = ""
    }
    cell.backgroundColor = UIColor.clearColor()
    
    return cell
  }

  @IBAction func close(segue: UIStoryboardSegue)
  {
    if let reviewViewController = segue.sourceViewController as? ReviewViewController
    {
      if let rating = reviewViewController.rating
      {
        place.rating = rating
        ratingButton.setImage(UIImage(named: rating), forState: UIControlState.Normal)
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        {
          do {
            try managedObjectContext.save()
          } catch {
            print(error)
          }
        }
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == "showMap"
    {
      let destinationController = segue.destinationViewController as! MapViewController
      destinationController.place = place
    }
  }
  
  
  
}