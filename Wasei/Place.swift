//
//  Place.swift
//  Wasei
//
//  Created by Chris Kong on 10/27/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import Foundation
import CoreData

class Place: NSManagedObject
{
  @NSManaged var name: String
  @NSManaged var type: String
  @NSManaged var address: String
  @NSManaged var image: NSData?
  @NSManaged var neighborhood: String?
  @NSManaged var phoneNumber: String?
  @NSManaged var hasWifi: NSNumber?
  @NSManaged var hasBabySeats: NSNumber?
  @NSManaged var rating: String?
  
//  init(name: String, type: String, address: String, image: String, neighborhood: String, phoneNumber: String, hasWifi: Bool, hasBabySeats: Bool, rating: String)
//  {
//    self.name = name
//    self.type = type
//    self.address = address
//    self.image = image
//    self.neighborhood = neighborhood
//    self.phoneNumber = phoneNumber
//    self.hasWifi = hasWifi
//    self.hasBabySeats = hasBabySeats
//    self.rating = rating
//  }
  
}