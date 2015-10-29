//
//  AddPlaceTableViewController.swift
//  Wasei
//
//  Created by Chris Kong on 10/27/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CoreData

class AddPlaceTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var typeTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var neighborhoodTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var wifiYesButton: UIButton!
  @IBOutlet weak var wifiNoButton: UIButton!
  @IBOutlet weak var babySeatsYesButton: UIButton!
  @IBOutlet weak var babySeatsNoButton: UIButton!
  
  var place: Place!
  var hasWifi = true
  var hasBabySeats = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Image Picker
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    if indexPath.row == 0
    {
      if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
      {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
      }
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
  {
    imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    imageView.contentMode = UIViewContentMode.ScaleAspectFill
    imageView.clipsToBounds = true
    
    let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
    leadingConstraint.active = true
    
    let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
    trailingConstraint.active = true
    
    let topConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    topConstraint.active = true
    
    let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    bottomConstraint.active = true
    
    dismissViewControllerAnimated(true, completion: nil)
  }

  // MARK: - Action methods
  
  @IBAction func saveAction(sender: UIBarButtonItem)
  {
    let name = nameTextField.text
    let type = typeTextField.text
    let address = addressTextField.text
    let neighborhood = neighborhoodTextField.text
    let phoneNumber = phoneNumberTextField.text
    
    // Validate input fields
    if name == "" || type == "" || address == ""
    {
      let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the required fields is blank. Please note that all fields are required.", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alertController, animated: true, completion: nil)
      return
    }
    
    if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    {
      place = NSEntityDescription.insertNewObjectForEntityForName("Place", inManagedObjectContext: managedObjectContext) as! Place
      place.name = name!
      place.type = type!
      place.address = address!
      place.neighborhood = neighborhood!
      place.phoneNumber = phoneNumber!
      
      if let placeImage = imageView.image
      {
        place.image = UIImagePNGRepresentation(placeImage)
      }
      
      place.hasWifi = hasWifi
      place.hasBabySeats = hasBabySeats
      
      do {
        try managedObjectContext.save()
      } catch {
        print(error)
        return
      }
    }
    
    // Dismiss the view controller
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func toggleHasWifiButton(sender: UIButton)
  {
    if sender == wifiYesButton
    {
      hasWifi = true
      wifiYesButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
      wifiNoButton.backgroundColor = UIColor.grayColor()
      
    } else if sender == wifiNoButton
    {
      hasWifi = false
      wifiYesButton.backgroundColor = UIColor.grayColor()
      wifiNoButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    }
  }
  
  @IBAction func toggleHasBabySeatsButton(sender: UIButton)
  {
    if sender == babySeatsYesButton
    {
      hasBabySeats = true
      babySeatsYesButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
      babySeatsNoButton.backgroundColor = UIColor.grayColor()
      
    } else if sender == babySeatsNoButton
    {
      hasBabySeats = false
      babySeatsYesButton.backgroundColor = UIColor.grayColor()
      babySeatsNoButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    }
  }
  
  
}