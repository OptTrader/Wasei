//
//  DetailsTableViewCell.swift
//  Wasei
//
//  Created by Chris Kong on 10/26/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell
{
  @IBOutlet weak var fieldLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}