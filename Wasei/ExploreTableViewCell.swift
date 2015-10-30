//
//  ExploreTableViewCell.swift
//  Wasei
//
//  Created by Chris Kong on 10/30/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell
{
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var neighborhoodLabel: UILabel!
  @IBOutlet weak var bgImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}