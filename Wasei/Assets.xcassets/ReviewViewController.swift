//
//  ReviewViewController.swift
//  Wasei
//
//  Created by Chris Kong on 10/26/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController
{
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var ratingStackView: UIStackView!
  @IBOutlet weak var dislikeButton: UIButton!
  @IBOutlet weak var goodButton: UIButton!
  @IBOutlet weak var greatButton: UIButton!
  
  var rating: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    // Apply a blurring effect to the background image view
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    backgroundImageView.addSubview(blurEffectView)
    
    let translate = CGAffineTransformMakeTranslation(0, 500)
    dislikeButton.transform = translate
    goodButton.transform = translate
    greatButton.transform = translate
  }
  
  override func viewDidAppear(animated: Bool)
  {
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
      self.dislikeButton.transform = CGAffineTransformIdentity
      }, completion: nil)
    
    UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
      self.goodButton.transform = CGAffineTransformIdentity
      }, completion: nil)
    
    UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
      self.greatButton.transform = CGAffineTransformIdentity
      }, completion: nil)
  }
  
  @IBAction func ratingSelected(sender: UIButton)
  {
    switch (sender.tag)
    {
      case 100: rating = "dislike"
      case 200: rating = "good"
      case 300: rating = "great"
      default: break
    }
    performSegueWithIdentifier("unwindToDetailView", sender: sender)
  }
  
}