//
//  WalkthroughContentViewController.swift
//  Wasei
//
//  Created by Chris Kong on 10/28/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController
{
  @IBOutlet weak var headingLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var contentImageView: UIImageView!
  @IBOutlet weak var forwardButton: UIButton!
  @IBOutlet weak var pageControl: UIPageControl!
  
  var index = 0
  var heading = ""
  var imageFile = ""
  var content = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    headingLabel.text = heading
    contentImageView.image = UIImage(named: imageFile)
    contentLabel.text = content
    
    // Set the current page
    pageControl.currentPage = index
    
    // Change the forward button's title
    switch index
    {
    case 0...1:
      forwardButton.setTitle("Next", forState: UIControlState.Normal)
    case 2:
      forwardButton.setTitle("Done", forState: UIControlState.Normal)
    default: break
    }
  }
  
  @IBAction func nextButtonTapped(sender: UIButton)
  {
    switch index
    {
    case 0...1:
      let pageViewController = parentViewController as! WalkthroughPageViewController
      pageViewController.forward(index)
      
    case 2:
      let defaults = NSUserDefaults.standardUserDefaults()
      defaults.setBool(true, forKey: "hasViewedWalkthrough")
      dismissViewControllerAnimated(true, completion: nil)
      
    default: break
    }
  }
  

}