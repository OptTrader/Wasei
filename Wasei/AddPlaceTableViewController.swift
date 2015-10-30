//
//  AddPlaceTableViewController.swift
//  Wasei
//
//  Created by Chris Kong on 10/27/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

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
  
  // MARK: - Table view data source
  
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
  
  // MARK: - UIImagePickerControllerDelegate methods
  
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
      let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the required fields is blank.", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    // Save the record to iCloud
    saveRecordToCloud(place)
    
    // Dismiss the view controller
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func toggleHasWifiButton(sender: UIButton)
  {
    // Yes button clicked
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
    // Yes button clicked
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
  
  // MARK: - CloudKit Methods
  
  func saveRecordToCloud(place: Place!) -> Void
  {
    // Prepare the record to save
    let record = CKRecord(recordType: "Place")
    record.setValue(place.name, forKey: "name")
    record.setValue(place.type, forKey: "type")
    record.setValue(place.address, forKey: "addressString")
    record.setValue(place.neighborhood, forKey: "neighborhood")
    record.setValue(place.phoneNumber, forKey: "phoneNumber")
    
    // Resize the image
    let originalImage = UIImage(data: place.image!)!
    let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
    let scaledImage = UIImage(data: place.image!, scale: scalingFactor)!
    
    // Write the image to local file for temporary use
    let imageFilePath = NSTemporaryDirectory() + place.name
    UIImageJPEGRepresentation(scaledImage, 0.8)?.writeToFile(imageFilePath, atomically: true)
    
    // Create image asset for upload
    let imageFileURL = NSURL(fileURLWithPath: imageFilePath)
    let imageAsset = CKAsset(fileURL: imageFileURL)
    record.setValue(imageAsset, forKey: "image")
    
    // Get the Public iCloud Database
    let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
    
    // Save the record to iCloud
    publicDatabase.saveRecord(record, completionHandler: { (record: CKRecord?, error: NSError?) -> Void in
      // Remove temp file
      do {
        try NSFileManager.defaultManager().removeItemAtPath(imageFilePath)
        
      } catch {
        
        print("Failed to save record to the cloud: \(error)")
      }
    })
  }
  
}