//
//  FavoritesTableViewCell.swift
//  Wasei
//
//  Created by Chris Kong on 10/26/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell
{
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}